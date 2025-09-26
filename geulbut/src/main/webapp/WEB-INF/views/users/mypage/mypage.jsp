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
    <h1 class="mb-4 text-accent-dark">마이페이지</h1>

    <div class="mypage-wrapper">
        <!-- ✅ 왼쪽 사이드 탭 -->
        <div class="mypage-sidebar nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
            <button class="nav-link active" id="v-pills-info-tab" data-bs-toggle="pill" data-bs-target="#v-pills-info" type="button" role="tab">내 정보</button>
            <button class="nav-link" id="v-pills-wishlist-tab" data-bs-toggle="pill" data-bs-target="#v-pills-wishlist" type="button" role="tab">위시리스트</button>
            <button class="nav-link" id="v-pills-cart-tab" data-bs-toggle="pill" data-bs-target="#v-pills-cart" type="button" role="tab">장바구니</button>
            <button class="nav-link" id="v-pills-orders-tab" data-bs-toggle="pill" data-bs-target="#v-pills-orders" type="button" role="tab">주문 내역</button>
        </div>

        <!-- ✅ 오른쪽 컨텐츠 -->
        <div class="mypage-content tab-content" id="v-pills-tabContent">

            <!-- ✅ 내 정보 -->
            <div class="tab-pane fade show active" id="v-pills-info" role="tabpanel">
                <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                    <h2 class="m-0">내 정보</h2>
                    <a href="<c:url value='/users/mypage/withdraw'/>" class="btn btn-outline-danger btn-sm">회원 탈퇴</a>
                </div>

                <c:if test="${not empty user}">
                    <p>아이디: ${user.userId}</p>
                    <p>이메일: ${user.email}</p>
                    <p>가입일: ${user.joinDate}</p>
                    <p>등급: ${user.grade}</p>
                    <p>포인트: ${user.point}</p>

                    <!-- ✅ 알림 메시지 -->
                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger mt-3">${errorMsg}</div>
                    </c:if>
                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success mt-3">${successMsg}</div>
                    </c:if>

                    <!-- ✅ 등급/누적금액 · 게이미피케이션 카드 -->
                    <div class="card mb-3 gamify-card"
                         id="gp-card"
                         data-total="${totalPurchase}"
                         data-progress="${progressPct}"
                         data-next-tier="${empty nextTier ? '' : nextTier}">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge rounded-pill
                                      <c:choose>
                                        <c:when test="${user.grade eq 'GOLD'}">bg-warning text-dark</c:when>
                                        <c:when test="${user.grade eq 'SILVER'}">bg-secondary</c:when>
                                        <c:otherwise>bg-bronze</c:otherwise>
                                      </c:choose>">
                                      등급 · ${user.grade}
                                    </span>
                                    <small class="text-muted">누적이 상승하면 자동 레벨업</small>
                                </div>
                                <div class="gp-coin-stack" title="누적 구매 금액">
                                    🪙 <span id="gp-total" class="gp-total">0</span> 원
                                </div>
                            </div>

                            <!-- 진행 바 + 마일스톤 -->
                            <div class="gp-rail">
                                <div class="gp-fill" id="gp-fill" style="width:0%;"></div>
                                <div class="gp-milestones">
                                    <div class="ms-dot" style="left:0%;"    title="BRONZE"></div>
                                    <div class="ms-dot" style="left:50%;"   title="SILVER (100,000)"></div>
                                    <div class="ms-dot" style="left:100%;"  title="GOLD (300,000)"></div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between">
                                <small>BRONZE</small>
                                <small>SILVER</small>
                                <small>GOLD</small>
                            </div>

                            <!-- 다음 티어 안내 -->
                            <div class="mt-2">
                                <c:choose>
                                    <c:when test="${empty nextTier}">
                                        <div class="text-success fw-semibold">축하합니다! 최고 등급(GOLD)입니다 🎉</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div>
                                            다음 등급(<strong>${nextTier}</strong>)까지
                                            <strong><fmt:formatNumber value="${amountToNext}" pattern="#,##0"/> 원</strong> 남았어요.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- 미션 / 성취 -->
                            <div class="gp-missions mt-3">
                                <div class="gp-m-title">미션</div>
                                <ul class="gp-m-list">
                                    <li class="${not empty orders ? 'done' : ''}">
                                        <span class="gp-check">✅</span> 첫 구매 완료
                                    </li>
                                    <li class="${totalPurchase >= 100000 ? 'done' : ''}">
                                        <span class="gp-check">✅</span> SILVER 달성
                                    </li>
                                    <li class="${totalPurchase >= 300000 ? 'done' : ''}">
                                        <span class="gp-check">✅</span> GOLD 달성
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- ✅ 임시비번 로그인 안내 -->
                    <c:if test="${forceChangePw}">
                        <div class="alert alert-warning d-flex align-items-center mb-3" role="alert">
                            <strong class="me-2">보안 안내</strong> 임시 비밀번호로 로그인했습니다. 지금 바로 비밀번호를 변경해 주세요.
                        </div>
                    </c:if>

                    <!-- ✅ 비밀번호 변경 폼 -->
                    <h3 class="mt-4 mb-3">비밀번호 변경</h3>
                    <c:choose>
                        <c:when test="${canChangePassword}">
                            <form method="post" action="<c:url value='/mypage/change-password'/>" class="row g-3">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <div class="col-12">
                                    <label for="currentPw" class="form-label">현재 비밀번호</label>
                                    <input type="password" id="currentPw" name="currentPw" class="form-control" required>
                                </div>
                                <div class="col-12">
                                    <label for="newPw" class="form-label">새 비밀번호</label>
                                    <input type="password" id="newPw" name="newPw" class="form-control" required>
                                </div>
                                <div class="col-12">
                                    <label for="confirmPw" class="form-label">새 비밀번호 확인</label>
                                    <input type="password" id="confirmPw" name="confirmPw" class="form-control" required>
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn btn-primary">비밀번호 변경</button>
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
                                <div class="d-flex align-items-center">
                                    <c:if test="${not empty book.imgUrl}">
                                        <img src="${book.imgUrl}" alt="${book.title}" class="img-thumbnail me-3" style="width:70px;height:auto;" onerror="this.src='/img/no-cover.png'">
                                    </c:if>
                                    <div>
                                        <strong>${book.title}</strong><br>
                                            ${book.authorName} | ${book.publisherName}<br>
                                        <c:choose>
                                            <c:when test="${not empty book.discountedPrice}">
                                                <span class="text-muted"><del><fmt:formatNumber value="${book.price}" pattern="#,##0"/></del></span>
                                                → <span class="text-danger fw-bold"><fmt:formatNumber value="${book.discountedPrice}" pattern="#,##0"/> 원</span>
                                            </c:when>
                                            <c:otherwise><fmt:formatNumber value="${book.price}" pattern="#,##0"/> 원</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="d-flex">
                                    <button type="button" class="btn btn-sm btn-outline-primary me-2" onclick="addToCart(${book.bookId}, this)">장바구니 담기</button>
                                    <button type="button" class="btn btn-sm btn-outline-danger ms-3" onclick="removeWishlist(${book.bookId}, this)">삭제</button>
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
                    <div class="list-group">
                        <c:forEach var="item" items="${cart}">
                            <div class="list-group-item d-flex">
                                <div class="me-3">
                                    <img src="${item.imgUrl}" alt="${item.title}" style="width:70px;height:100px;object-fit:cover;" onerror="this.src='/img/no-cover.png'">
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${item.title}</h6>
                                    <p class="mb-1 text-muted small">
                                        수량:
                                        <input type="number" value="${item.quantity}" min="1" class="form-control form-control-sm d-inline-block" style="width:70px;" onchange="updateCart(${item.bookId}, this.value)">
                                    </p>
                                    <p class="mb-1">
                                        <c:choose>
                                            <c:when test="${not empty item.discountedPrice}">
                                                <span class="text-muted"><del><fmt:formatNumber value="${item.price}" pattern="#,##0"/> 원</del></span>
                                                → <span class="fw-bold text-danger"><fmt:formatNumber value="${item.discountedPrice}" pattern="#,##0"/> 원</span>
                                            </c:when>
                                            <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,##0"/> 원</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p class="fw-bold text-accent-dark">가격: <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0"/> 원</p>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeCart(${item.bookId}, this)">삭제</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="mt-3 text-end">
                        <h5>총합: <fmt:formatNumber value="${cartTotal}" pattern="#,##0"/> 원</h5>
                        <button class="btn btn-primary" onclick="Orders.openOrderInfoModal(${cartTotal})">💳 결제하기</button>
                    </div>
                </c:if>
            </div>

            <!-- ✅ 주문 내역 -->
            <div class="tab-pane fade" id="v-pills-orders" role="tabpanel">
                <h2 class="mb-3 pb-2 border-bottom">주문 내역</h2>

                <c:if test="${empty orders}">
                    <div class="alert alert-info">주문 내역이 없습니다.</div>
                </c:if>

                <c:if test="${not empty orders}">
                    <div class="orders-list">
                        <c:forEach var="order" items="${orders}">
                            <div class="card mb-3 shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex overflow-auto mb-2" style="gap:8px;">
                                        <c:forEach var="item" items="${order.items}">
                                            <img src="${item.imageUrl}" alt="${item.title}" style="width:60px;height:85px;object-fit:cover;border-radius:4px;" onerror="this.src='/img/no-cover.png'">
                                        </c:forEach>
                                    </div>

                                    <c:forEach var="item" items="${order.items}">
                                        <div><strong>${item.title}</strong> <span class="text-muted">x ${item.quantity}</span></div>
                                    </c:forEach>

                                    <div class="fw-bold text-primary mt-2"><fmt:formatNumber value="${order.totalPrice}" pattern="#,##0"/> 원</div>
                                    <div class="text-muted small">주문일: ${order.createdAt}</div>

                                    <div class="mt-2">
                                        <c:choose>
                                            <c:when test="${order.status eq 'PAID'}">
                                                <span class="badge bg-primary">결제 완료</span>
                                                <button class="btn btn-sm btn-outline-danger ms-2" onclick="Orders.updateOrderStatus(${order.orderId}, 'CANCELLED')">취소</button>
                                            </c:when>
                                            <c:when test="${order.status eq 'SHIPPED'}">
                                                <span class="badge bg-info text-dark">배송중</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'DELIVERED'}">
                                                <span class="badge bg-success">배송완료</span>
                                                <button class="btn btn-sm btn-outline-warning ms-2" onclick="Orders.updateOrderStatus(${order.orderId}, 'REFUND_REQUEST')">환불 신청</button>
                                            </c:when>
                                            <c:when test="${order.status eq 'CANCELLED'}">
                                                <span class="badge bg-secondary">취소됨</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'REFUND_REQUEST'}">
                                                <span class="badge bg-warning text-dark">환불 신청 중</span>
                                            </c:when>
                                            <c:when test="${order.status eq 'REFUNDED'}">
                                                <span class="badge bg-dark">환불 완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-light text-dark">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
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
</script>

<!-- 3) PortOne SDK -->
<script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

<!-- 4) imp_code 주입 (반드시 cart.js보다 먼저 존재) -->
<div id="imp-root" data-imp-code="${impCode}"></div>

<!-- 5) 공통/주문 스크립트 -->
<script src="/js/mypage/mypage-common.js"></script>
<script src="/js/mypage/orders.js"></script>

<!-- 6) 장바구니 -->
<script src="/js/mypage/cart.js"></script>

<!-- 7) 위시리스트 -->
<script src="/js/mypage/wishlist.js"></script>

<jsp:include page="paymentModal.jsp"/>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>
