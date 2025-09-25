// /js/admin/bs_quartz_actions.js
// Bootswatch Quartz(Secondary) 버튼 + 모달을 Shadow DOM 안에서만 적용하는 커스텀 컴포넌트
// 팀 규칙 준수: 스타일 태그 X, 전역 CSS 오염 X, JS 파일 분리 O, 백엔드 수정 X

(function () {
    const QUARTZ_CSS = "https://cdn.jsdelivr.net/npm/bootswatch@5.3.3/dist/quartz/bootstrap.min.css";

    class BsActions extends HTMLElement {
        constructor() {
            super();
            this.attachShadow({ mode: "open" });

            // 템플릿: Secondary 버튼 두 개 + Bootstrap 모달 마크업
            const wrapper = document.createElement("div");
            wrapper.innerHTML = `
        <link rel="stylesheet" href="${QUARTZ_CSS}">
        <style>
          /* 전역 오염 방지: Shadow DOM 내부에서만 적용되는 보조 스타일 (reset용) */
          :host { display: inline-block; }
          .btn-group { display:inline-flex; gap:8px; }
          /* 모달 크기 살짝 조정(디폴트 그대로 써도 OK) */
          .modal-dialog { max-width: 420px; }
        </style>

        <div class="btn-group">
          <button type="button" class="btn btn-secondary btn-sm" id="btnSave">저장</button>
          <button type="button" class="btn btn-secondary btn-sm" id="btnDelete">삭제</button>
        </div>

        <!-- Bootstrap modal 구조를 그대로 사용 (행동은 우리가 JS로 제어) -->
        <div class="modal fade" tabindex="-1" id="confirmModal" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">확인</h5>
                <button type="button" class="btn-close" aria-label="Close" id="modalCloseX"></button>
              </div>
              <div class="modal-body" id="modalBody">처리하시겠습니까?</div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" id="modalCancel">취소</button>
                <button type="button" class="btn btn-secondary" id="modalOk">확인</button>
              </div>
            </div>
          </div>
        </div>
      `;

            this.shadowRoot.appendChild(wrapper);

            // DOM refs (shadow 내부)
            this.$btnSave = this.shadowRoot.getElementById("btnSave");
            this.$btnDelete = this.shadowRoot.getElementById("btnDelete");
            this.$modal = this.shadowRoot.getElementById("confirmModal");
            this.$modalTitle = this.shadowRoot.getElementById("modalTitle");
            this.$modalBody = this.shadowRoot.getElementById("modalBody");
            this.$modalOk = this.shadowRoot.getElementById("modalOk");
            this.$modalCancel = this.shadowRoot.getElementById("modalCancel");
            this.$modalCloseX = this.shadowRoot.getElementById("modalCloseX");

            // 상태
            this._pendingAction = null; // "save" | "delete"
        }

        connectedCallback() {
            // 클릭 이벤트 연결
            this.$btnSave.addEventListener("click", () => this._openConfirm("save"));
            this.$btnDelete.addEventListener("click", () => this._openConfirm("delete"));

            // 모달 버튼
            const close = () => this._hideModal();
            this.$modalCancel.addEventListener("click", close);
            this.$modalCloseX.addEventListener("click", close);
            this.$modalOk.addEventListener("click", () => this._doAction());
        }

        // 유틸: 같은 행(tr) 안의 select들을 light DOM에서 찾아 값 읽기
        _getRowContext() {
            const userId = this.getAttribute("user-id");
            const hostTr = this.closest("tr"); // light DOM 상의 행
            if (!hostTr) return { userId, role: null, status: null };

            const roleSelect = hostTr.querySelector(".role-select");
            const statusSelect = hostTr.querySelector(".status-select");

            return {
                userId,
                role: roleSelect ? roleSelect.value : null,
                status: statusSelect ? statusSelect.value : null
            };
        }

        _openConfirm(type) {
            this._pendingAction = type;

            const userName = (this.getAttribute("user-name") || "").trim();
            const { role, status } = this._getRowContext();

            if (type === "save") {
                this.$modalTitle.textContent = "권한 변경";
                this.$modalBody.innerHTML =
                    `사용자 <strong>${userName || ""}</strong>님의 권한을 <strong>${role}</strong>로 변경할까요?`;
                this._showModal();
            } else if (type === "delete") {
                this.$modalTitle.textContent = "회원 삭제";
                this.$modalBody.innerHTML =
                    `사용자 <strong>${userName || ""}</strong>를 정말 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.`;
                this._showModal();
            }
        }

        _showModal() {
            // Bootstrap JS 없이 모달 토글 (필요한 클래스/스타일만 제어)
            this.$modal.classList.add("show");
            this.$modal.style.display = "block";
            this.$modal.removeAttribute("aria-hidden");
            this.$modal.setAttribute("aria-modal", "true");

            // 백드롭 생성 (Shadow DOM 내부로)
            this._backdrop = document.createElement("div");
            this._backdrop.className = "modal-backdrop fade show";
            this.shadowRoot.appendChild(this._backdrop);
        }

        _hideModal() {
            if (this._backdrop) {
                this._backdrop.remove();
                this._backdrop = null;
            }
            this.$modal.classList.remove("show");
            this.$modal.style.display = "none";
            this.$modal.setAttribute("aria-hidden", "true");
            this.$modal.removeAttribute("aria-modal");
            this._pendingAction = null;
        }

        async _doAction() {
            const { userId, role, status } = this._getRowContext();
            if (!userId) { this._hideModal(); return; }

            try {
                if (this._pendingAction === "save") {
                    // 기존 엔드포인트와 동일하게 호출 (권한 저장)
                    const res = await fetch(`/admin/api/users/${userId}/role?newRole=${encodeURIComponent(role)}`, { method: "PUT" });
                    if (!res.ok) throw new Error("권한 변경 실패");
                    alert("권한이 변경되었습니다.");
                    location.reload();

                } else if (this._pendingAction === "delete") {
                    // 기존 엔드포인트와 동일하게 호출 (회원 삭제)
                    const res = await fetch(`/admin/api/users/${userId}`, { method: "DELETE" });
                    if (!res.ok) throw new Error("회원 삭제 실패");
                    alert("회원이 삭제되었습니다.");
                    location.reload();
                }
            } catch (err) {
                console.error(err);
                alert(err.message || "요청 처리 실패");
            } finally {
                this._hideModal();
            }
        }
    }

    customElements.define("bs-actions", BsActions);
})();
