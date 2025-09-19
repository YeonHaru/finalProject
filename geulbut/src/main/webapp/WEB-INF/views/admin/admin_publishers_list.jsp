<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>관리자 - 출판사 관리</title>

    <!-- 공통/헤더 + 출판사 전용 CSS -->
    <link rel="stylesheet" href="${ctx}/css/00_common.css" />
    <link rel="stylesheet" href="${ctx}/css/header.css" />
    <link rel="stylesheet" href="${ctx}/css/admin/admin-publishers.css" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body class="bg-main text-main admin-publishers">
<jsp:include page="/common/header.jsp" />

<div class="page">
    <h1 class="mt-4 mb-4">출판사 관리</h1>

    <!-- 검색 -->
    <div class="search-wrapper">
        <form id="publisherSearchForm" method="get" action="${ctx}/admin/publishers" class="search-form">
            <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="출판사 ID/이름 검색" />
            <button type="submit" class="btn-search">검색</button>
        </form>
    </div>

    <!-- 상단 툴바 -->
    <div class="toolbar">
        <button type="button" class="btn btn-accent" id="btnAddPublisher">출판사 등록</button>
    </div>

    <!-- 출판사 목록 -->
    <div class="table-scroll">
        <table class="admin-table admin-publishers-table" id="publishersTable">
            <colgroup>
                <col class="col-id" />
                <col class="col-name" />
                <col class="col-desc" />
                <col class="col-created" />
                <col class="col-actions" />
            </colgroup>
            <thead>
            <tr>
                <th>ID</th>
                <th>이름</th>
                <th>설명</th>
                <th>생성일</th>
                <th>작업</th>
            </tr>
            </thead>
            <tbody id="publishersTableBody">
            <c:forEach var="publisher" items="${publishersPage.content}">
                <tr class="data-row"
                    data-id="${publisher.publisherId}"
                    data-name="${publisher.name}"
                    data-description="${publisher.description}">
                    <td>${publisher.publisherId}</td>
                    <td class="t-left publisher-name">${publisher.name}</td>
                    <td class="t-left publisher-description">${publisher.description}</td>
                    <td class="created-at-cell">${publisher.createdAt}</td>
                    <td>
                        <button type="button" class="btn btn-accent btn-edit">수정</button>
                        <button type="button" class="btn btn-delete">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 페이지네이션 -->
    <c:if test="${publishersPage.totalPages > 0}">
        <div class="pagination mt-2">
            <c:forEach begin="0" end="${publishersPage.totalPages - 1}" var="i">
                <c:url var="pageUrl" value="${ctx}/admin/publishers">
                    <c:param name="keyword" value="${param.keyword}" />
                    <c:param name="page" value="${i}" />
                </c:url>
                <a href="${pageUrl}" class="${i == publishersPage.number ? 'active' : ''}">${i + 1}</a>
            </c:forEach>
        </div>
    </c:if>
</div>

<!-- 모달: 도서/작가와 동일한 구조/클래스 -->
<div id="publisherModal" aria-hidden="true" role="dialog" aria-modal="true" style="display:none;">
    <div class="modal__dialog" role="document">
        <div class="modal__header">
            <h3 id="modalTitle">출판사 등록</h3>
            <button type="button" class="modal__close" id="btnCloseModal" aria-label="닫기">×</button>
        </div>

        <form id="publisherForm" class="modal__form">
            <input type="hidden" id="modalPublisherId" />

            <label>출판사 이름
                <input type="text" id="modalPublisherName" placeholder="출판사명을 입력하세요" required />
            </label>

            <label style="grid-column:1 / -1;">설명
                <textarea id="modalPublisherDescription" rows="4" placeholder="간단한 설명을 입력하세요"></textarea>
            </label>

            <div class="modal__footer">
                <button type="button" class="btn" id="btnCancel">닫기</button>
                <button type="submit" class="btn btn-accent" id="modalSaveBtn">저장</button>
            </div>
        </form>
    </div>
</div>

<script src="${ctx}/js/admin/admin_publishers.js?v=1"></script>
</body>
</html>
