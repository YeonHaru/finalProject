<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>배송조회</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<c:url value='/css/00_common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/orders/deliveryInfo.css'/>">
</head>
<body>
<main class="page page--track" aria-labelledby="pageTitle">
    <h1 id="pageTitle" class="sr-only">배송조회</h1>

    <!-- 뷰모델 바인딩 -->
    <c:set var="o" value="${delivery.ordersDto}"/>
    <c:set var="vStatus" value="${delivery.viewDeliveryStatus}"/>

    <!-- DEBUG -->
    <p>DEBUG: vStatus = ${vStatus}, o.status = ${o.status}</p>

    <!-- 탭 -->
    <div class="tabs" role="tablist" aria-label="배송 상태">
        <button class="tab ${vStatus == 'READY' ? 'is-active' : ''}"
                role="tab" aria-selected="${vStatus == 'READY'}"
                aria-controls="panel-ready" id="tab-ready">배송준비</button>

        <button class="tab ${vStatus == 'IN_TRANSIT' ? 'is-active' : ''}"
                role="tab" aria-selected="${vStatus == 'IN_TRANSIT'}"
                aria-controls="panel-intransit" id="tab-intransit">배송중</button>

        <button class="tab ${vStatus == 'DELIVERED' ? 'is-active' : ''}"
                role="tab" aria-selected="${vStatus == 'DELIVERED'}"
                aria-controls="panel-delivered" id="tab-delivered">배송완료</button>
    </div>

    <!-- 패널: 배송준비 -->
    <section class="panel ${vStatus == 'READY' ? 'is-active' : ''}"
             role="tabpanel" id="panel-ready" aria-labelledby="tab-ready"
    ${vStatus == 'READY' ? '' : 'hidden'}>
        <article class="card">
            <header class="card__header">
                <h2 class="card__title">배송준비</h2>
                <span class="status status--ready">Ready</span>
            </header>

            <div class="grid grid--2">
                <div class="kv">
                    <span class="k">택배사</span>
                    <span class="v">${empty o.courierName ? '—' : o.courierName}</span>
                </div>
                <div class="kv">
                    <span class="k">송장번호</span>
                    <span class="v">${empty o.invoiceNo ? '—' : o.invoiceNo}</span>
                </div>
                <div class="kv">
                    <span class="k">예상도착</span>
                    <span class="v">
            <c:choose>
                <c:when test="${vStatus == 'DELIVERED' && not empty o.deliveredAtFormatted}">
                    ${o.deliveredAtFormatted}
                </c:when>
                <c:when test="${vStatus == 'IN_TRANSIT'}">
                    출고 후 1~2일 내 도착 예상
                </c:when>
                <c:when test="${vStatus == 'READY'}">
                    준비중 (결제 완료 기준)
                </c:when>
                <c:otherwise>—</c:otherwise>
            </c:choose>
          </span>
                </div>
            </div>

            <!-- 상세 토글 -->
            <button class="detail-toggle" aria-expanded="false" aria-controls="detail-ready">상세보기</button>
            <div id="detail-ready" class="detail" hidden>
                <ul class="detail-list">
                    <li>결제수단: ${empty o.paymentMethod ? '—' : o.paymentMethod}</li>
                    <li>수취인: ${empty o.recipient ? '—' : o.recipient}</li>
                    <li>배송지: ${empty o.address ? '—' : o.address}</li>

                    <!-- 주문상품 목록 -->
                    <li>주문상품 목록</li>
                    <c:choose>
                        <c:when test="${not empty o.items}">
                            <ul class="order-items">
                                <c:forEach var="it" items="${o.items}">
                                    <li class="order-item">
                                        <div class="oi-wrap">
                                            <c:if test="${not empty it.imageUrl}">
                                                <img src="${it.imageUrl}" alt="${it.title}" class="oi-thumb"/>
                                            </c:if>
                                            <div class="oi-info">
                                                <div class="oi-title">${it.title}</div>
                                                <div class="oi-meta">
                                                    수량: ${it.quantity}
                                                    · 단가: <fmt:formatNumber value="${it.price}" type="number"/>원
                                                    · 소계: <fmt:formatNumber value="${it.price * it.quantity}" type="number"/>원
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p class="muted">주문상품 정보가 없습니다.</p>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </article>
    </section>

    <!-- 패널: 배송중 -->
    <section class="panel ${vStatus == 'IN_TRANSIT' ? 'is-active' : ''}"
             role="tabpanel" id="panel-intransit" aria-labelledby="tab-intransit"
    ${vStatus == 'IN_TRANSIT' ? '' : 'hidden'}>
        <article class="card">
            <header class="card__header">
                <h2 class="card__title">배송중</h2>
                <span class="status status--in">In Transit</span>
            </header>

            <div class="grid grid--2">
                <div class="kv">
                    <span class="k">송장번호</span>
                    <span class="v">${empty o.invoiceNo ? '—' : o.invoiceNo}</span>
                </div>
                <div class="kv">
                    <span class="k">택배사</span>
                    <span class="v">${empty o.courierName ? '—' : o.courierName}</span>
                </div>
                <div class="kv">
                    <span class="k">기사님</span>
                    <span class="v">${empty o.courierManName ? '—' : o.courierManName}</span>
                </div>
                <div class="kv">
                    <span class="k">연락처</span>
                    <span class="v">${empty o.courierManPhone ? '—' : o.courierManPhone}</span>
                </div>
            </div>

            <button class="detail-toggle" aria-expanded="false" aria-controls="detail-intransit">상세 이동경로</button>
            <div id="detail-intransit" class="detail" hidden>
                <p class="detail-list">이동 경로 정보가 준비되어 있지 않습니다.</p>
            </div>
        </article>
    </section>

    <!-- 패널: 배송완료 (현재 주문 + 지난 내역을 한 블록에서 열기) -->
    <section class="panel ${vStatus == 'DELIVERED' ? 'is-active' : ''}"
             role="tabpanel" id="panel-delivered" aria-labelledby="tab-delivered"
    ${vStatus == 'DELIVERED' ? '' : 'hidden'}>

        <article class="card">
            <header class="card__header">
                <h2 class="card__title">배송완료</h2>
                <span class="status status--done">Delivered</span>
            </header>

            <!-- 요약 정보(항상 보임) -->
            <div class="grid grid--2">
                <div class="kv">
                    <span class="k">도착시간</span>
                    <span class="v">
          <c:choose>
              <c:when test="${not empty o.deliveredAtFormatted}">
                  ${o.deliveredAtFormatted}
              </c:when>
              <c:when test="${not empty o.deliveredAt}">
                  <fmt:formatDate value="${o.deliveredAt}" pattern="yyyy-MM-dd (E) HH:mm"/>
              </c:when>
              <c:otherwise>—</c:otherwise>
          </c:choose>
        </span>
                </div>
                <div class="kv">
                    <span class="k">수령인</span>
                    <span class="v">${empty o.recipient ? '—' : o.recipient}</span>
                </div>
                <div class="kv">
                    <span class="k">배송지</span>
                    <span class="v">${empty o.address ? '—' : o.address}</span>
                </div>
            </div>

            <!-- ✅ 이 버튼 하나로 "현재 주문 상세 + 지난 배송완료 내역" 둘 다 펼침 -->
            <button class="detail-toggle" aria-expanded="false" aria-controls="detail-delivered">
                상세보기
            </button>

            <div id="detail-delivered" class="detail" hidden>
                <!-- 현재 주문 상세 -->
                <h3 class="sub-title">현재 주문 상세 (주문 #${o.orderId})</h3>
                <ul class="detail-list">
                    <li>송장번호: ${empty o.invoiceNo ? '—' : o.invoiceNo}</li>
                    <li>택배사: ${empty o.courierName ? '—' : o.courierName}</li>
                    <li>결제수단: ${empty o.paymentMethod ? '—' : o.paymentMethod}</li>
                    <li>수취인: ${empty o.recipient ? '—' : o.recipient}</li>
                    <li>배송지: ${empty o.address ? '—' : o.address}</li>
                </ul>

                <!-- 현재 주문 상품 목록 -->
                <c:if test="${not empty o.items}">
                    <ul class="order-items">
                        <c:forEach var="it" items="${o.items}">
                            <li class="order-item">
                                <div class="oi-wrap">
                                    <c:if test="${not empty it.imageUrl}">
                                        <img src="${it.imageUrl}" alt="${it.title}" class="oi-thumb"/>
                                    </c:if>
                                    <div class="oi-info">
                                        <div class="oi-title">${it.title}</div>
                                        <div class="oi-meta">
                                            수량: ${it.quantity}
                                            · 단가: <fmt:formatNumber value="${it.price}" type="number"/>원
                                            · 소계: <fmt:formatNumber value="${it.price * it.quantity}" type="number"/>원
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:if>

                <!-- 지난 배송완료 내역 -->
                <h3 class="sub-title">지난 배송완료 내역</h3>
                <c:choose>
                    <c:when test="${not empty history}">
                        <ul class="history-list compact">
                            <c:forEach var="h" items="${history}">
                                <c:url var="detailUrl" value="/orders/${h.orderId}/delivery"/>
                                <li class="history-row">
                                    <a class="row-link" href="${detailUrl}">
                                        <span class="h-col no">#${h.orderId}</span>
                                        <span class="h-col date">
                    <c:choose>
                        <c:when test="${not empty h.deliveredAtFormatted}">${h.deliveredAtFormatted}</c:when>
                        <c:when test="${not empty h.deliveredAt}">
                            <fmt:formatDate value="${h.deliveredAt}" pattern="yyyy-MM-dd (E) HH:mm"/>
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                  </span>
                                        <span class="h-col sum"><fmt:formatNumber value="${h.totalPrice}" type="number"/>원</span>
                                        <span class="h-col items">
                    <c:choose>
                        <c:when test="${not empty h.items}">
                            <c:set var="cnt" value="${fn:length(h.items)}"/>
                            <c:set var="first" value="${h.items[0]}"/>
                            ${first.title}<c:if test="${cnt > 1}"> 외 ${cnt - 1}건</c:if>
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                  </span>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="muted">표시할 배송완료 내역이 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </article>
    </section>



</main>

<!-- JS: 탭/토글 -->
<script>
    (function(){
        const TAB_KEY = 'delivery.activeTabId';
        const OPEN_KEY = 'delivery.openDetailIds';

        const tabs   = document.querySelectorAll('.tab');
        const panels = document.querySelectorAll('.panel');
        const detailButtons = document.querySelectorAll('.detail-toggle');

        // 유틸: 열려있는 detail id 집합을 세션에 저장/로드
        function loadOpenSet(){
            try { return new Set(JSON.parse(sessionStorage.getItem(OPEN_KEY) || '[]')); }
            catch { return new Set(); }
        }
        function saveOpenSet(set){
            sessionStorage.setItem(OPEN_KEY, JSON.stringify(Array.from(set)));
        }

        function activateTab(targetId){
            tabs.forEach(t => {
                const active = (t.getAttribute('aria-controls') === targetId);
                t.classList.toggle('is-active', active);
                t.setAttribute('aria-selected', active);
            });
            panels.forEach(p => {
                const active = (p.id === targetId);
                p.classList.toggle('is-active', active);
                p.hidden = !active;
            });
            sessionStorage.setItem(TAB_KEY, targetId);
        }

        // 상세 토글 버튼 바인딩 (+ 상태 저장)
        detailButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.getAttribute('aria-controls');
                const panel = document.getElementById(id);
                const openSet = loadOpenSet();

                const expanded = btn.getAttribute('aria-expanded') === 'true';
                const willExpand = !expanded;

                btn.setAttribute('aria-expanded', String(willExpand));
                panel.hidden = !willExpand;
                btn.textContent = willExpand ? '접기' : '상세보기';

                if (willExpand) openSet.add(id); else openSet.delete(id);
                saveOpenSet(openSet);
            });
        });

        // 탭 전환 이벤트 (+ 상태 저장)
        tabs.forEach(tab => {
            const targetId = tab.getAttribute('aria-controls');
            const onActivate = () => activateTab(targetId);

            tab.addEventListener('click', onActivate);
            tab.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    onActivate();
                }
            });
        });

        // “지난 배송완료 내역” 링크 클릭 직전에 현재 상태 저장 (탭/열림 유지)
        document.querySelectorAll('.history-list .row-link').forEach(a => {
            a.addEventListener('click', () => {
                // 현재 활성 탭 찾기
                const currentActive = Array.from(panels).find(p => p.classList.contains('is-active'));
                if (currentActive) sessionStorage.setItem(TAB_KEY, currentActive.id);

                // 현재 열려있는 detail 수집
                const openIds = Array.from(detailButtons)
                    .filter(b => b.getAttribute('aria-expanded') === 'true')
                    .map(b => b.getAttribute('aria-controls'));
                sessionStorage.setItem(OPEN_KEY, JSON.stringify(openIds));
            }, { capture: true }); // 캡처 단계에서 먼저 저장 보장
        });

        // 초기 복원 로직: 저장된 탭/디테일 열림 상태 복원
        function restoreState(){
            const savedTabId = sessionStorage.getItem(TAB_KEY);
            if (savedTabId && document.getElementById(savedTabId)) {
                activateTab(savedTabId);
            } else {
                // 서버 렌더 상태를 존중하되, 현재 .panel.is-active가 없다면 첫 번째 탭 활성화
                const current = Array.from(panels).find(p => p.classList.contains('is-active') && !p.hidden);
                if (!current && panels[0]) activateTab(panels[0].id);
            }

            const openSet = loadOpenSet();
            detailButtons.forEach(btn => {
                const id = btn.getAttribute('aria-controls');
                const shouldOpen = openSet.has(id);
                btn.setAttribute('aria-expanded', String(shouldOpen));
                const panel = document.getElementById(id);
                if (panel) panel.hidden = !shouldOpen;
                btn.textContent = shouldOpen ? '접기' : '상세보기';
            });
        }

        // DOM 준비되면 복원
        restoreState();
    })();
</script>
</body>
</html>
