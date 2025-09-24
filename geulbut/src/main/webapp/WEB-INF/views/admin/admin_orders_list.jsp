<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>관리자 주문 관리</title>
</head>
<!-- 공통/헤더 + 관리자 통합 CSS -->
<link rel="stylesheet" href="${ctx}/css/00_common.css" />
<link rel="stylesheet" href="${ctx}/css/header.css" />
<link rel="stylesheet" href="${ctx}/css/admin/admin.css" />

<script>
  // JS에서 컨텍스트 경로 사용
  window.ctx = "${ctx}";
</script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<body>
<jsp:include page="/common/admin_page_header.jsp" />
<h1>주문 관리</h1>

<!-- 상태 & 유저ID 필터 -->
<form method="get" action="/admin/orders">
  <label for="status">상태:</label>
  <select name="status" id="status">
    <option value="">전체</option>
    <option value="CREATED" ${status == 'CREATED' ? 'selected' : ''}>생성됨</option>
    <option value="PAID" ${status == 'PAID' ? 'selected' : ''}>결제 완료</option>
    <option value="SHIPPED" ${status == 'SHIPPED' ? 'selected' : ''}>배송중</option>
    <option value="DELIVERED" ${status == 'DELIVERED' ? 'selected' : ''}>배송완료</option>
    <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>취소</option>
    <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>대기</option>
  </select>

  <label for="userId">사용자ID:</label>
  <input type="text" name="userId" id="userId" value="${userId != null ? userId : ''}" placeholder="아이디 입력">

  <button type="submit">검색</button>
</form>

<!-- 주문 목록 테이블 -->
<table border="1" cellpadding="5" cellspacing="0">
  <thead>
  <tr>
    <th>주문ID</th>
    <th>사용자ID</th>
    <th>사용자 이름</th>
    <th>총액</th>
    <th>상태</th>
    <th>결제수단</th>
    <th>주문번호</th> <!-- 추가 -->
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
    <c:when test="${not empty ordersPage}">
      <c:forEach var="order" items="${ordersPage.content}">
        <tr>
          <td>${order.orderId}</td>
          <td>${order.userId}</td>
          <td>${order.userName}</td>
          <td>${order.totalPrice}</td>
          <td>
            <select class="status-select" data-id="${order.orderId}" data-current-status="${order.status}">
              <option value="PENDING" ${order.status=='PENDING'?'selected':''}>대기</option>
              <option value="PAID" ${order.status=='PAID'?'selected':''}>결제 완료</option>
              <option value="SHIPPED" ${order.status=='SHIPPED'?'selected':''}>배송중</option>
              <option value="DELIVERED" ${order.status=='DELIVERED'?'selected':''}>배송완료</option>
              <option value="CANCELLED" ${order.status=='CANCELLED'?'selected':''}>취소</option>
            </select>
          </td>
          <td>${order.paymentMethod}</td>
          <td>${order.merchantUid}</td> <!-- 추가 -->
          <td>${order.recipient}</td>
          <td>${order.address}</td>
          <td>${order.createdAt}</td>
          <td>${order.paidAt}</td>
          <td>${order.deliveredAt}</td>
          <td>
            <button class="btn-detail" data-id="${order.orderId}">상세보기</button>
          </td>
        </tr>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <c:forEach var="order" items="${ordersList}">
        <tr>
          <td>${order.orderId}</td>
          <td>${order.userId}</td>
          <td>${order.userName}</td>
          <td>${order.totalPrice}</td>
          <td>
            <select class="status-select" data-id="${order.orderId}" data-current-status="${order.status}">
              <option value="PENDING" ${order.status=='PENDING'?'selected':''}>대기</option>
              <option value="PAID" ${order.status=='PAID'?'selected':''}>결제 완료</option>
              <option value="SHIPPED" ${order.status=='SHIPPED'?'selected':''}>배송중</option>
              <option value="DELIVERED" ${order.status=='DELIVERED'?'selected':''}>배송완료</option>
              <option value="CANCELLED" ${order.status=='CANCELLED'?'selected':''}>취소</option>
            </select>
          </td>
          <td>${order.paymentMethod}</td>
          <td>${order.merchantUid}</td> <!-- 추가 -->
          <td>${order.recipient}</td>
          <td>${order.address}</td>
          <td>${order.createdAt}</td>
          <td>
            <button class="btn-detail" data-id="${order.orderId}">상세보기</button>
          </td>
        </tr>
      </c:forEach>
    </c:otherwise>
  </c:choose>
  </tbody>
</table>

<!-- 페이징 -->
<c:if test="${not empty ordersPage}">
  <div class="pagination">
    <c:forEach begin="0" end="${ordersPage.totalPages - 1}" var="i">
      <a href="?page=${i}&size=${ordersPage.size}&status=${status}"
         class="${i == ordersPage.number ? 'active' : ''}">${i + 1}</a>
    </c:forEach>
  </div>
</c:if>

<!-- 주문 상세 모달 -->
<div id="orderDetailModal" style="display:none; position:fixed; top:50%; left:50%;
     transform:translate(-50%,-50%); background:#fff; padding:20px; border:1px solid #000;">
  <h3>주문 상세</h3>
  <div id="orderDetailContent"></div>
  <button id="closeModal">닫기</button>
</div>

<script src="/js/admin/admin_orders.js"></script>
</body>
</html>
