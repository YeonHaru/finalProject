<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/footer.css">
    <link rel="stylesheet" href="/css/mypage/mypage.css">
</head>

<body>
<jsp:include page="/common/header.jsp"></jsp:include>


<div class="container my-5">
    <div class="mypage-wrapper">
        <!-- ✅ 왼쪽 사이드 탭 -->
        <div class="mypage-sidebar nav flex-column nav-pills" id="v-pills-tab" role="tablist"
             aria-orientation="vertical">
            <h4 class="mb-3 text-accent-dark text-center mt-3">마이페이지</h4>
            <button class="nav-link active" id="v-pills-info-tab" data-bs-toggle="pill" data-bs-target="#v-pills-info"
                    type="button" role="tab">내 정보
            </button>
            <button class="nav-link" id="v-pills-wishlist-tab" data-bs-toggle="pill" data-bs-target="#v-pills-wishlist"
                    type="button" role="tab">위시리스트
            </button>
            <button class="nav-link" id="v-pills-cart-tab" data-bs-toggle="pill" data-bs-target="#v-pills-cart"
                    type="button" role="tab">장바구니
            </button>
            <button class="nav-link" id="v-pills-orders-tab" data-bs-toggle="pill" data-bs-target="#v-pills-orders"
                    type="button" role="tab">주문 내역
            </button>
        </div>

        <!-- ✅ 오른쪽 컨텐츠 -->
        <div class="mypage-content tab-content" id="v-pills-tabContent">

            <!-- ✅ 내 정보 -->
            <div class="tab-pane fade show active" id="v-pills-info" role="tabpanel">
                <!-- 여기만 교체 -->
                <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                    <h2 class="m-0">내 정보</h2>
                </div>
                <!-- 여기까지 교체 -->

                <c:if test="${not empty user}">
                    <p>아이디: ${user.userId}</p>
                    <p>이메일: ${user.email}</p>
                    <p>가입일: ${user.joinDate}</p>
                    <p>등급: ${user.grade}</p>
                    <p>포인트: <strong><fmt:formatNumber value="${user.point}" pattern="#,##0"/></strong> P</p>

                    <!-- ✅ 알림 메시지 -->
                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger mt-3">${errorMsg}</div>
                    </c:if>
                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success mt-3">${successMsg}</div>
                    </c:if>
                    <%-- 덕규 알람 메시지 추가--%>
                    <!-- ✅ 등급/누적금액 요약 -->
                    <div class="card mb-3">
                        <div class="card-body d-flex align-items-center justify-content-between">
                            <div>
                                <div>
                                    누적 구매 금액:
                                    <strong><fmt:formatNumber value="${totalPurchase}" pattern="#,##0"/> 원</strong>
                                </div>

                                <c:choose>
                                    <c:when test="${empty nextTier}">
                                        <div class="text-success">축하합니다! 최고 등급(GOLD)입니다</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div>
                                            다음 등급(<strong>${nextTier}</strong>)까지
                                            <strong><fmt:formatNumber value="${amountToNext}" pattern="#,##0"/>
                                                원</strong> 남았어요.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="flex-grow-1 ms-4" style="min-width:240px;">
                                <div class="progress" style="height:10px;">
                                    <div class="progress-bar" role="progressbar"
                                         style="width:${progressPct}%;" aria-valuenow="${progressPct}"
                                         aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <small class="text-muted">${progressPct}%</small>
                            </div>
                        </div>
                    </div>

                    <%--                    덕규 알람 메시지 추가--%>
                    <c:if test="${forceChangePw}">
                        <div class="alert alert-warning d-flex align-items-center mb-3" role="alert">
                            <strong class="me-2">보안 안내</strong>
                            임시 비밀번호로 로그인했습니다. 지금 바로 비밀번호를 변경해 주세요.
                        </div>
                        <script>
                            document.addEventListener('DOMContentLoaded', () => {
                                // 1) "내 정보" 탭 강제 활성화
                                const infoTab = document.getElementById('v-pills-info-tab');
                                if (infoTab) infoTab.click();

                                // 2) 비밀번호 변경 섹션으로 스크롤 + 현재 비번 입력창 포커스
                                const cur = document.getElementById('currentPw');
                                if (cur) {
                                    cur.scrollIntoView({behavior: 'smooth', block: 'center'});
                                    cur.focus();
                                }

                                // 3) 시각 강조(선택)
                                const form = document.querySelector('form[action$="/mypage/change-password"]');
                                if (form) {
                                    form.classList.add('border', 'border-warning', 'rounded-3');
                                    setTimeout(() => form.classList.remove('border', 'border-warning', 'rounded-3'), 3000);
                                }
                            });
                        </script>
                    </c:if>

                    <!-- ✅ 비밀번호 변경 폼 -->
                    <h3 class="mt-4 mb-3">비밀번호 변경</h3>

                    <c:choose>
                        <c:when test="${canChangePassword}">
                            <form method="post" action="<c:url value='/mypage/change-password'/>" class="row g-3">
                                <!-- CSRF 토큰 (Spring Security 켜져있으면 필수) -->
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <div class="col-12">
                                    <label for="currentPw" class="form-label">현재 비밀번호</label>
                                    <input type="password" id="currentPw" name="currentPw" class="form-control"
                                           required>
                                </div>
                                <div class="col-12">
                                    <label for="newPw" class="form-label">새 비밀번호</label>
                                    <input type="password" id="newPw" name="newPw" class="form-control" required>
                                </div>
                                <div class="col-12">
                                    <label for="confirmPw" class="form-label">새 비밀번호 확인</label>
                                    <input type="password" id="confirmPw" name="confirmPw" class="form-control"
                                           required>
                                </div>
                                <div class="col-12 d-flex justify-content-between align-items-center">
                                    <button type="submit" class="btn btn-primary">비밀번호 변경</button>
                                    <a href="<c:url value='/users/mypage/withdraw'/>" class="btn btn-outline-danger red-background">
                                        회원 탈퇴
                                    </a>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info">
                                소셜 로그인(구글/네이버/카카오) 사용자는 비밀번호 변경 기능을 사용할 수 없습니다.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>

            <!-- ✅ 위시리스트 -->
            <div class="tab-pane fade" id="v-pills-wishlist" role="tabpanel">
                <h2 class="mb-3 pb-2 border-bottom">위시리스트</h2>

                <c:if test="${empty wishlist}">
                    <div class="alert alert-info">위시리스트에 담긴 책이 없습니다.</div>
                </c:if>

                <c:if test="${not empty wishlist}">
                    <ul class="list-group">
                        <c:forEach var="book" items="${wishlist}">
                            <li class="list-group-item d-flex align-items-center justify-content-between">

                                <!-- 책 정보 -->
                                <div class="d-flex align-items-center">
                                    <!-- 표지 이미지 -->
                                    <c:if test="${not empty book.imgUrl}">
                                        <img src="${book.imgUrl}" alt="${book.title}"
                                             class="img-thumbnail me-3" style="width:70px; height:auto;">
                                    </c:if>

                                    <!-- 텍스트 정보 -->
                                    <div>
                                        <strong>${book.title}</strong><br>
                                            ${book.authorName} | ${book.publisherName}<br>
                                        <c:choose>
                                            <c:when test="${not empty book.discountedPrice}">
                                    <span class="text-muted">
                                        <del><fmt:formatNumber value="${book.price}" pattern="#,##0"/></del>
                                    </span>
                                                → <span class="text-danger fw-bold">
                                        <fmt:formatNumber value="${book.discountedPrice}" pattern="#,##0"/> 원
                                    </span>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${book.price}" pattern="#,##0"/> 원
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- 액션 버튼 -->
                                <div class="d-flex">
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary me-2"
                                            onclick="addToCart(${book.bookId}, this)">
                                        장바구니 담기
                                    </button>
                                    <button type="button"
                                            class="btn btn-sm btn-outline-danger ms-3"
                                            onclick="removeWishlist(${book.bookId}, this)">
                                        삭제
                                    </button>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:if>
            </div>

            <!-- ✅ 장바구니 -->
            <div class="tab-pane fade" id="v-pills-cart" role="tabpanel">
                <h2 class="mb-3 pb-2 border-bottom">장바구니</h2>

                <c:if test="${empty cart}">
                    <div class="alert alert-info">장바구니가 비어 있습니다.</div>
                </c:if>

                <c:if test="${not empty cart}">
                    <div class="list-group w-100">
                        <c:forEach var="item" items="${cart}">
                            <div class="list-group-item d-flex">
                                <!-- ✅ 책 이미지 -->
                                <div class="me-3">
                                    <img src="${item.imgUrl}" alt="${item.title}"
                                         style="width:70px; height:100px; object-fit:cover;">
                                </div>

                                <!-- ✅ 책 정보 -->
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${item.title}</h6>
                                    <p class="mb-1 text-muted small">
                                        수량:
                                        <input type="number"
                                               value="${item.quantity}" min="1"
                                               class="form-control form-control-sm d-inline-block"
                                               style="width:70px;"
                                               onchange="updateCart(${item.bookId}, this.value)">
                                    </p>
                                    <p class="mb-1">
                                        <c:choose>
                                            <c:when test="${not empty item.discountedPrice}">
                                <span class="text-muted">
                                    <del><fmt:formatNumber value="${item.price}" pattern="#,##0"/> 원</del>
                                </span>
                                                → <span class="fw-bold text-danger">
                                    <fmt:formatNumber value="${item.discountedPrice}" pattern="#,##0"/> 원
                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${item.price}" pattern="#,##0"/> 원
                                            </c:otherwise>
                                        </c:choose>
                                    </p>

                                    <p class="fw-bold text-accent-dark">
                                        가격: <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0"/> 원
                                    </p>

                                    <!-- ✅ 삭제 버튼 -->
                                    <button type="button"
                                            class="btn btn-sm btn-outline-danger"
                                            onclick="removeCart(${item.bookId}, this)">
                                        삭제
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- ✅ 총합 영역 -->
                    <div class="mt-3 text-end">
                        <h5>
                            총합: <fmt:formatNumber value="${cartTotal}" pattern="#,##0"/> 원
                        </h5>
                        <button class="btn btn-primary"
                                onclick="Orders.openOrderInfoModal(${cartTotal})">💳 결제하기
                        </button>
                    </div>
                </c:if>
            </div>

            <!-- 주문 내역 (SSR 제거: 스켈레톤 + 렌더 타깃만 남김) -->
            <div class="tab-pane fade" id="v-pills-orders" role="tabpanel">
                <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                    <h2 class="m-0">주문 내역</h2>

                <c:choose>
                    <c:when test="${not empty sessionScope.lastOrderId}">
                        <c:url var="dlvUrl" value="/orders/${sessionScope.lastOrderId}/delivery"/>
                        <a href="${dlvUrl}" class="btn btn-outline-secondary btn-sm">배송조회</a>
                    </c:when>
                    <c:otherwise>
                        <!-- 주문내역 탭으로 이동(SSR/JS 로딩 위치 유지) -->
                        <c:url var="mypageOrdersUrl" value="/users/mypage">
                            <c:param name="tab" value="orders"/>
                        </c:url>
                        <a href="${mypageOrdersUrl}" class="btn btn-outline-secondary btn-sm">배송조회</a>
                    </c:otherwise>
                </c:choose>
            </div>

                <!-- 스켈레톤: JS 로딩 전 잠깐 표시 -->
                <div id="orders-skeleton">
                    <div class="card mb-3">
                        <div class="card-body d-flex align-items-center">
                            <div class="me-3" style="width:60px;height:85px;border-radius:6px;background:#eee;"></div>
                            <div class="flex-grow-1">
                                <div class="placeholder-glow"><span class="placeholder col-6"></span></div>
                                <div class="placeholder-glow"><span class="placeholder col-4"></span></div>
                                <div class="placeholder-glow"><span class="placeholder col-3"></span></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 실제 렌더 타깃 (JS가 여기에 카드+아코디언을 그립니다) -->
                <div id="orders-root" class="orders-list"></div>

                <!-- 페이지네이션(선택) -->
                <nav aria-label="주문 내역 페이지네이션" class="mt-3">
                    <ul id="orders-pagination" class="pagination pagination-sm justify-content-center"></ul>
                </nav>

                <noscript>
                    <div class="alert alert-warning mt-3">주문 내역을 보려면 자바스크립트를 활성화하세요.</div>
                </noscript>
            </div>
        </div>
    </div>
</div>

<!-- 1) 부트스트랩 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 2) 전역값 (csrf, userId 등) -->
<script>
    window.csrfHeaderName = "${_csrf.headerName}";
    window.csrfToken = "${_csrf.token}";
    window.currentUserId = "${user.userId}";
    window.forceChangePw = "${forceChangePw}";
</script>

<!-- 3) PortOne SDK -->
<script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

<!-- 4) imp_code 주입 (반드시 cart.js보다 먼저 존재) -->
<div id="imp-root" data-imp-code="${impCode}"></div>

<!-- 5) 나머지 공통/주문 스크립트 -->
<script src="/js/mypage/mypage-common.js"></script>

<script src="/js/mypage/orders.js"></script>

<!-- 6) 방금 교체한 cart.js (마지막에) -->
<script src="/js/mypage/cart.js"></script>


<!-- 7) 위시리스트 -->
<script src="/js/mypage/wishlist.js"></script>
<%-- 버튼 클릭시 이동 경로 --%>
<%--<a href="/mypage?tab=wishlist"> 위시리스트</a>--%>
<%--<a href="/mypage?tab=cart"> 장바구니</a>--%>
<%--주문내역 리뷰쓰기--%>
<script>
    function writeReview(orderId) {
        location.href = '/reviews/write?orderId=' + orderId;
    }
</script>


<jsp:include page="paymentModal.jsp"/>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>
