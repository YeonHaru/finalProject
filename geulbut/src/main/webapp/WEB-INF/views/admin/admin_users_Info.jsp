<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>

    <title>관리자 - 회원조회</title>
    <link rel="stylesheet" href="${ctx}/css/00_common.css" />
    <link rel="stylesheet" href="${ctx}/css/header.css" />
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 외부 JS 분리 -->
    <script src="/js/admin/admin_users_Info.js"></script>
    <script src="/js/theme.js"></script>
</head>
<body class="bg-main text-main admin-users has-bg">
<jsp:include page="/common/admin_page_header.jsp"></jsp:include>

<div class="page">
    <h1 class="mt-4 mb-4">회원 관리</h1>

    <!-- 검색창 통합 -->
    <div class="search-wrapper admin-search-form">
        <form method="get" action="/admin/users-info" class="search-form">
            <!-- 검색 입력창 -->
            <input id="q" name="keyword" type="text" placeholder="회원ID, 이름, 이메일 검색" value="${keyword}"/>
            <!-- 검색 버튼 -->
            <button type="submit" class="btn-search">검색</button>
            <!-- 세부 검색 토글 -->
            <button type="button" id="toggleAdvancedSearch" class="btn-search" style="background:#ccc; color:#000;">
                조건검색 ▼
            </button>
        </form>

        <!-- 세부검색 -->
        <div id="advancedSearch" class="advanced-search" style="display:none;">
            <label for="startDate">가입일:</label>
            <input type="date" id="startDate" name="startDate" value="${startDate}">
            <span>~</span>
            <input type="date" id="endDate" name="endDate" value="${endDate}">

            <label for="roleFilter">권한:</label>
            <select id="roleFilter" name="roleFilter">
                <option value="">전체</option>
                <option value="USER" ${roleFilter == 'USER' ? 'selected' : ''}>USER</option>
                <option value="ADMIN" ${roleFilter == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                <option value="MANAGER" ${roleFilter == 'MANAGER' ? 'selected' : ''}>MANAGER</option>
            </select>

            <label for="statusFilter">계정 상태:</label>
            <select id="statusFilter" name="statusFilter">
                <option value="">전체</option>
                <option value="ACTIVE" ${statusFilter == 'ACTIVE' ? 'selected' : ''}>활성</option>
                <option value="INACTIVE" ${statusFilter == 'INACTIVE' ? 'selected' : ''}>비활성</option>
                <option value="DELETED" ${statusFilter == 'DELETED' ? 'selected' : ''}>삭제</option>
                <option value="SUSPENDED" ${statusFilter == 'SUSPENDED' ? 'selected' : ''}>정지</option>
            </select>
        </div>
    </div>

    <!-- 통계 -->
    <div class="stats mt-3">
        <p>총 회원수: <span id="totalUsers">...</span></p>
        <p>오늘 가입자수: <span id="todayNewUsers">...</span></p>
    </div>

    <!-- 회원 테이블 -->
    <div class="table-scroll">
        <table class="admin-table admin-users-table">
            <colgroup>
                <col class="col-id">
                <col class="col-name">
                <col class="col-email">
                <col class="col-phone">
                <col class="col-address">
                <col class="col-role">
                <col class="col-joindate">
                <col class="col-status">
                <col class="col-actions">
            </colgroup>
            <thead>
            <tr>
                <th>회원ID</th>
                <th>이름</th>
                <th>이메일</th>
                <th>전화번호</th>
                <th>기본주소</th>
                <th>권한</th>
                <th>가입일</th>
                <th>계정상태</th>
                <th>액션</th>
            </tr>
            </thead>
        <tbody>
        <c:forEach var="user" items="${usersPage.content}">
            <tr class="data-row">
                <td>${user.userId}</td>
                <td>${user.name}</td>
                <td>${user.email != null ? user.email : '-'}</td>
                <td>${user.phone != null ? user.phone : '-'}</td>
                <td>${user.address != null ? user.address : '-'}</td>
                <td>
                    <select class="role-select" data-userid="${user.userId}">
                        <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>USER</option>
                        <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                        <option value="MANAGER" ${user.role == 'MANAGER' ? 'selected' : ''}>MANAGER</option>
                    </select>
                </td>
                <td>${user.joinDate}</td>
                <td>
                    <select class="status-select" data-userid="${user.userId}">
                        <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>활성</option>
                        <option value="INACTIVE" ${user.status == 'INACTIVE' ? 'selected' : ''}>비활성</option>
                        <option value="DELETED" ${user.status == 'DELETED' ? 'selected' : ''}>삭제</option>
                        <option value="SUSPENDED" ${user.status == 'SUSPENDED' ? 'selected' : ''}>정지</option>
                    </select>
                </td>
                <td>
                    <button class="btn btn-cer-secondary save-btn" data-userid="${user.userId}">저장</button>
                    <button class="btn btn-cer-success   delete-btn" data-userid="${user.userId}">삭제</button>
                </td>
            </tr>

            <tr class="detail-row" style="display:none;">
                <td colspan="9">
                    <div class="detail-content">
                        <p><strong>회원ID:</strong> ${user.userId}</p>
                        <p><strong>이름:</strong> ${user.name}</p>
                        <p><strong>이메일:</strong> ${user.email != null ? user.email : '-'}</p>
                        <p><strong>전화번호:</strong> ${user.phone != null ? user.phone : '-'}</p>
                        <p><strong>주소:</strong> ${user.address != null ? user.address : '-'}</p>
                        <p><strong>권한:</strong> ${user.role}</p>
                        <p><strong>가입일:</strong> ${user.joinDate}</p>
                        <p><strong>계정상태:</strong> ${user.status}</p>
                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    </div>
    <!-- 페이지네이션 -->
    <c:if test="${usersPage.totalPages > 0}">
        <nav aria-label="페이지 이동">
            <ul class="pagination materia justify-center">
                <!-- 이전 -->
                <li class="page-item ${usersPage.number == 0 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="?keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&roleFilter=${roleFilter}&statusFilter=${statusFilter}&page=${usersPage.number - 1}&size=${usersPage.size}">
                        이전
                    </a>
                </li>

                <!-- 숫자 -->
                <c:forEach begin="0" end="${usersPage.totalPages - 1}" var="i">
                    <li class="page-item ${i == usersPage.number ? 'active' : ''}">
                        <a class="page-link"
                           href="?keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&roleFilter=${roleFilter}&statusFilter=${statusFilter}&page=${i}&size=${usersPage.size}">
                                ${i + 1}
                        </a>
                    </li>
                </c:forEach>

                <!-- 다음 -->
                <li class="page-item ${usersPage.number >= usersPage.totalPages - 1 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="?keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&roleFilter=${roleFilter}&statusFilter=${statusFilter}&page=${usersPage.number + 1}&size=${usersPage.size}">
                        다음
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<p class="ht-footnote">© Geulbut Admin Users Info</p>
<script src="/js/admin/bs_quartz_actions.js"></script>
</body>
</html>
