<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <div class="mypage-sidebar nav flex-column nav-pills" id="v-pills-tab" role="tablist"
             aria-orientation="vertical">
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
                <h2 class="mb-3 pb-2 border-bottom">내 정보</h2>

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

                    <!-- ✅ 비밀번호 변경 폼 -->
                    <h3 class="mt-4 mb-3">비밀번호 변경</h3>
                    <form method="post" action="<c:url value='/mypage/change-password'/>" class="row g-3">
                        <!-- CSRF 토큰 (Spring Security 켜져있으면 필수) -->
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
                                                <span class="text-muted"><del><fmt:formatNumber value="${book.price}"
                                                                                                pattern="#,##0"/></del></span>
                                                → <span class="text-danger fw-bold"><fmt:formatNumber
                                                    value="${book.discountedPrice}" pattern="#,##0"/> 원</span>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${book.price}" pattern="#,##0"/> 원
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="d-flex">
                                    <!-- 장바구니 담기 버튼 -->
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary me-2"
                                            onclick="addToCart(${book.bookId}, this)">
                                        장바구니 담기
                                    </button>

                                    <!-- 삭제 버튼 (AJAX) -->
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

                <c:if test="${not empty cart}">
                    <!-- 장바구니 폼 -->
                    <form method="post" action="<c:url value='/cart/update'/>">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table class="table table-striped align-middle">
                            <thead>
                            <tr>
                                <th>상품</th>
                                <th style="width:120px;">수량</th>
                                <th>가격</th>
                                <th>합계</th>
                                <th style="width:150px;">관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${cart}">
                                <tr>
                                    <td>${item.title}</td>
                                    <td>
                                        <input type="number" name="qty_${item.bookId}"
                                               value="${item.quantity}" min="1"
                                               class="form-control form-control-sm"
                                               onchange="updateCart(${item.bookId}, this.value)">
                                    </td>
                                    <td><fmt:formatNumber value="${item.price}" pattern="#,##0"/> 원</td>
                                    <td><fmt:formatNumber value="${item.totalPrice}" pattern="#,##0"/> 원</td>
                                    <td>
                                        <button type="button"
                                                class="btn btn-sm btn-outline-danger"
                                                onclick="removeCart(${item.bookId}, this)">
                                            삭제
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="2"></td>
                                <td class="text-end"><strong>총합</strong></td>
                                <td><strong><fmt:formatNumber value="${cartTotal}" pattern="#,##0"/> 원</strong></td>
                                <td class="text-end">
                                    <button class="btn btn-primary">💳 결제하기</button>
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </form>
                </c:if>

                <c:if test="${empty cart}">
                    <p class="text-light">장바구니가 비어 있습니다.</p>
                </c:if>
            </div>

            <!-- ✅ 주문 내역 -->
            <div class="tab-pane fade" id="v-pills-orders" role="tabpanel">
                <h2 class="mb-3 pb-2 border-bottom">주문 내역</h2>
                <c:if test="${not empty orders}">
                    <table class="table table-striped align-middle">
                        <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>주문일</th>
                            <th>상품</th>
                            <th>금액</th>
                            <th>상태</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.orderDate}</td>
                                <td>${order.productName}</td>
                                <td><fmt:formatNumber value="${order.amount}" pattern="#,##0"/> 원</td>
                                <td>${order.status}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- CSRF 토큰 전역 변수 -->
<script>
    window.csrfToken = '${_csrf.token}';
</script>

<!-- 마이페이지 전용 JS -->
<script src="/js/mypage/mypage.js"></script>

<%-- 버튼 클릭시 이동 경로 --%>
<%--<a href="/mypage?tab=wishlist"> 위시리스트</a>--%>
<%--<a href="/mypage?tab=cart"> 장바구니</a>--%>

<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>
