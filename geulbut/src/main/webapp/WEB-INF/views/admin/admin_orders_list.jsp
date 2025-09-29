<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<html>
<head>
    <title>관리자 주문 관리</title>
    <link rel="stylesheet" href="${ctx}/css/00_common.css"/>
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>window.ctx = "${ctx}";</script>
</head>
<body class="p-4 bg-surface text-main">

<jsp:include page="/common/admin_page_header.jsp"/>

<h1 class="mb-4 text-xl font-bold">주문 관리</h1>

<!-- 검색 영역 -->
<form method="get" action="${ctx}/admin/orders" class="flex items-center gap-3 mb-6">
    <label for="status">상태:</label>
    <select name="status" id="status" class="border rounded-sm px-2 py-1">
        <option value="">전체</option>
        <option value="CREATED"   ${status=='CREATED'?'selected':''}>생성됨</option>
        <option value="PAID"      ${status=='PAID'?'selected':''}>결제 완료</option>
        <option value="SHIPPED"   ${status=='SHIPPED'?'selected':''}>배송중</option>
        <option value="DELIVERED" ${status=='DELIVERED'?'selected':''}>배송완료</option>
        <option value="CANCELLED" ${status=='CANCELLED'?'selected':''}>취소</option>
        <option value="PENDING"   ${status=='PENDING'?'selected':''}>대기</option>
    </select>

    <label for="userId">사용자ID:</label>
    <input type="text" name="userId" id="userId"
           value="${userId != null ? userId : ''}"
           placeholder="아이디 입력"
           class="border rounded-sm px-2 py-1"/>

    <button type="submit"
            class="border rounded-sm px-3 py-1 bg-accent text-invert shadow-sm">
        검색
    </button>
</form>

<!-- 주문 테이블 -->
<table class="table-auto border-collapse border shadow-sm rounded-sm w-full text-sm">
    <thead class="bg-main text-light">
    <tr>
        <th class="px-2 py-1 border">주문ID</th>
        <th class="px-2 py-1 border">사용자ID</th>
        <th class="px-2 py-1 border">사용자 이름</th>
        <th class="px-2 py-1 border">총액</th>
        <th class="px-2 py-1 border">상태</th>
        <th class="px-2 py-1 border">결제수단</th>
        <th class="px-2 py-1 border">주문번호</th>
        <th class="px-2 py-1 border">수령인</th>
        <th class="px-2 py-1 border">주소</th>
        <th class="px-2 py-1 border">주문일</th>
        <th class="px-2 py-1 border">결제일시</th>
        <th class="px-2 py-1 border">배송일시</th>
        <th class="px-2 py-1 border">상세보기</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${not empty ordersPage and not empty ordersPage.content}">
            <c:forEach var="order" items="${ordersPage.content}">
                <tr class="hover:bg-surface-variant">
                    <td class="px-2 py-1 border">${order.orderId}</td>
                    <td class="px-2 py-1 border">${order.userId}</td>
                    <td class="px-2 py-1 border">${order.userName != null ? order.userName : '-'}</td>
                    <td class="px-2 py-1 border">${order.totalPrice != null ? order.totalPrice : '-'}</td>
                    <td class="px-2 py-1 border">
                        <select class="status-select border rounded-sm px-2 py-1"
                                data-id="${order.orderId}"
                                data-current-status="${order.status}">
                            <option value="PENDING"   ${order.status=='PENDING'?'selected':''}>대기</option>
                            <option value="PAID"      ${order.status=='PAID'?'selected':''}>결제 완료</option>
                            <option value="SHIPPED"   ${order.status=='SHIPPED'?'selected':''}>배송중</option>
                            <option value="DELIVERED" ${order.status=='DELIVERED'?'selected':''}>배송완료</option>
                            <option value="CANCELLED" ${order.status=='CANCELLED'?'selected':''}>취소</option>
                        </select>
                    </td>
                    <td class="px-2 py-1 border">${order.paymentMethod != null ? order.paymentMethod : '-'}</td>
                    <td class="px-2 py-1 border">${order.merchantUid != null ? order.merchantUid : '-'}</td>
                    <td class="px-2 py-1 border">${order.recipient != null ? order.recipient : '-'}</td>
                    <td class="px-2 py-1 border">${order.address != null ? order.address : '-'}</td>
                    <td class="px-2 py-1 border"
                        data-date="${order.createdAt != null ? order.createdAt : ''}">
                            ${order.createdAt != null ? order.createdAt : '-'}
                    </td>
                    <td class="px-2 py-1 border"
                        data-date="${order.paidAt != null ? order.paidAt : ''}">
                            ${order.paidAt != null ? order.paidAt : '-'}
                    </td>
                    <td class="px-2 py-1 border deliveredAt"
                        data-date="${order.deliveredAt != null ? order.deliveredAt : ''}"
                        data-created="${order.createdAt != null ? order.createdAt : ''}"
                        data-status="${order.status != null ? order.status : ''}">
                            ${order.deliveredAt != null ? order.deliveredAt : '-'}
                    </td>
                    <td class="px-2 py-1 border text-center">
                        <button class="btn-detail border rounded-sm px-2 py-1 bg-surface shadow-sm"
                                data-id="${order.orderId}">
                            상세보기
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="13" class="px-2 py-4 text-center border">조회된 주문이 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<!-- 페이지네이션 -->
<c:if test="${not empty ordersPage and ordersPage.totalPages > 0}">
    <div class="pagination flex gap-2 mt-4">
        <c:forEach begin="0" end="${ordersPage.totalPages - 1}" var="i">
            <a href="?page=${i}&size=${ordersPage.size}&status=${status}"
               class="px-3 py-1 border rounded-sm ${i==ordersPage.number?'bg-accent text-invert':''}">
                    ${i+1}
            </a>
        </c:forEach>
    </div>
</c:if>

<!-- 주문 상세 모달 -->
<div id="orderDetailModal" class="modal">
    <div class="modal-content">
        <span id="closeModal" class="modal-close">&times;</span>
        <h3>주문 상세</h3>
        <div id="orderDetailContent"></div>
        <div class="text-right">
            <button id="closeModalBottom">닫기</button>
        </div>
    </div>
</div>


<script src="${ctx}/js/admin/admin_orders.js"></script>
</body>
</html>
