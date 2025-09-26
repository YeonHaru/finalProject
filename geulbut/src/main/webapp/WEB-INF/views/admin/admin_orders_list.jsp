<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>관리자 주문 관리</title>
    <link rel="stylesheet" href="${ctx}/css/00_common.css"/>
    <link rel="stylesheet" href="${ctx}/css/header.css"/>
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>window.ctx = "${ctx}";</script>
</head>
<body>
<jsp:include page="/common/admin_page_header.jsp"/>
<h1>주문 관리</h1>

<form method="get" action="/admin/orders">
    <label for="status">상태:</label>
    <select name="status" id="status">
        <option value="">전체</option>
        <option value="CREATED" ${status=='CREATED'?'selected':''}>생성됨</option>
        <option value="PAID" ${status=='PAID'?'selected':''}>결제 완료</option>
        <option value="SHIPPED" ${status=='SHIPPED'?'selected':''}>배송중</option>
        <option value="DELIVERED" ${status=='DELIVERED'?'selected':''}>배송완료</option>
        <option value="CANCELLED" ${status=='CANCELLED'?'selected':''}>취소</option>
        <option value="PENDING" ${status=='PENDING'?'selected':''}>대기</option>
    </select>

    <label for="userId">사용자ID:</label>
    <input type="text" name="userId" id="userId" value="${userId != null ? userId : ''}" placeholder="아이디 입력">

    <button type="submit">검색</button>
</form>

<table border="1" cellpadding="5" cellspacing="0">
    <thead>
    <tr>
        <th>주문ID</th>
        <th>사용자ID</th>
        <th>사용자 이름</th>
        <th>총액</th>
        <th>상태</th>
        <th>결제수단</th>
        <th>주문번호</th>
        <th>수령인</th>
        <th>주소</th>
        <th>주문일</th>
        <th>결제일시</th>
        <th>배송일시</th>
        <th>상세보기</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${not empty ordersPage and not empty ordersPage.content}">
            <c:forEach var="order" items="${ordersPage.content}">
                <tr>
                    <td>${order.orderId}</td>
                    <td>${order.userId}</td>
                    <td>${order.userName != null ? order.userName : '-'}</td>
                    <td>${order.totalPrice != null ? order.totalPrice : '-'}</td>
                    <td>
                        <select class="status-select" data-id="${order.orderId}" data-current-status="${order.status}">
                            <option value="PENDING" ${order.status=='PENDING'?'selected':''}>대기</option>
                            <option value="PAID" ${order.status=='PAID'?'selected':''}>결제 완료</option>
                            <option value="SHIPPED" ${order.status=='SHIPPED'?'selected':''}>배송중</option>
                            <option value="DELIVERED" ${order.status=='DELIVERED'?'selected':''}>배송완료</option>
                            <option value="CANCELLED" ${order.status=='CANCELLED'?'selected':''}>취소</option>
                        </select>
                    </td>
                    <td>${order.paymentMethod != null ? order.paymentMethod : '-'}</td>
                    <td>${order.merchantUid != null ? order.merchantUid : '-'}</td>
                    <td>${order.recipient != null ? order.recipient : '-'}</td>
                    <td>${order.address != null ? order.address : '-'}</td>
                    <td data-date="${order.createdAt != null ? order.createdAt : ''}">${order.createdAt != null ? order.createdAt : '-'}</td>
                    <td data-date="${order.paidAt != null ? order.paidAt : ''}">${order.paidAt != null ? order.paidAt : '-'}</td>
                    <td class="deliveredAt"
                        data-date="${order.deliveredAt != null ? order.deliveredAt : ''}"
                        data-created="${order.createdAt != null ? order.createdAt : ''}"
                        data-status="${order.status != null ? order.status : ''}">
                            ${order.deliveredAt != null ? order.deliveredAt : '-'}
                    </td>
                    <td>
                        <button class="btn-detail" data-id="${order.orderId}">상세보기</button>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="13" style="text-align:center;">조회된 주문이 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<c:if test="${not empty ordersPage and ordersPage.totalPages > 0}">
    <div class="pagination">
        <c:forEach begin="0" end="${ordersPage.totalPages - 1}" var="i">
            <a href="?page=${i}&size=${ordersPage.size}&status=${status}"
               class="${i==ordersPage.number?'active':''}">${i+1}</a>
        </c:forEach>
    </div>
</c:if>

<div id="orderDetailModal" style="display:none; position:fixed; top:50%; left:50%;
     transform:translate(-50%,-50%); background:#fff; padding:20px; border:1px solid #000; z-index:9999; max-width:90%; overflow:auto;">
    <h3>주문 상세</h3>
    <div id="orderDetailContent"></div>
    <button id="closeModal">닫기</button>
</div>

<script src="${ctx}/js/admin/admin_orders.js"></script>
</body>
</html>
