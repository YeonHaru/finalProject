<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>리뷰 작성</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/footer.css">
    <link rel="stylesheet" href="/css/mypage/mypage.css">

    <style>
        .review-page {
            min-height: 100vh;
            background: var(--color-bg);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: var(--space-6) 0;
        }

        .review-card {
            background: var(--color-surface);
            border: 1px solid var(--color-border);
            box-shadow: var(--shadow-sm);
            border-radius: var(--radius-lg);
            padding: var(--space-5);
            width: min(92%, 700px);
        }

        .review-header {
            text-align: center;
            margin-bottom: var(--space-4);
        }

        .book-info {
            display: flex;
            gap: var(--gap-3);
            align-items: flex-start;
            margin-bottom: var(--space-4);
        }

        .book-info img {
            width: 100px;
            height: 140px;
            object-fit: cover;
            border-radius: var(--radius-sm);
            border: 1px solid var(--color-border);
        }

        .book-info .book-title {
            font-weight: bold;
            font-size: 1.25rem;
            color: var(--color-text);
        }

        .star-rating {
            display: flex;
            justify-content: center;
            gap: var(--gap-2);
            margin-bottom: var(--space-3);
        }

        .star {
            font-size: 2rem;
            color: var(--color-border);
            cursor: pointer;
            transition: color var(--dur) var(--ease);
        }

        .star.active {
            color: gold;
        }

        textarea.review-text {
            width: 100%;
            height: 160px;
            padding: var(--space-3);
            border: 1px solid var(--color-border);
            border-radius: var(--radius);
            resize: none;
        }

        .btn-submit {
            display: block;
            width: 100%;
            margin-top: var(--space-4);
            padding: var(--space-3);
            background: var(--color-accent-dark);
            color: #fff;
            border-radius: var(--radius);
            transition: background var(--dur) var(--ease);
        }

        .btn-submit:hover {
            background: var(--color-accent);
        }
        .review-subtitle {
            color: var(--color-accent);  /* 혹은 var(--color-accent-dark) */
            font-size: 1rem;
        }
    </style>
</head>
<body>
<jsp:include page="/common/header.jsp" />

<div class="review-page">
    <div class="review-card">
        <div class="review-header">
            <h2>리뷰 작성</h2>
            <p class="review-subtitle">상품에 대한 솔직한 후기를 남겨주세요</p>
        </div>

        <!-- 책 정보 -->
        <div class="book-info">
            <img src="${item.imageUrl}" alt="${item.title}">
            <div class="book-title">${item.title}</div>
        </div>

        <!-- 별점 -->
        <div class="star-rating" id="starRating">
            <span class="star" data-value="1">★</span>
            <span class="star" data-value="2">★</span>
            <span class="star" data-value="3">★</span>
            <span class="star" data-value="4">★</span>
            <span class="star" data-value="5">★</span>
        </div>

        <!-- 리뷰 내용 -->
        <textarea class="review-text" id="reviewText" placeholder="리뷰를 입력하세요"></textarea>

        <!-- 등록 버튼 -->
        <button class="btn-submit" id="submitReview">리뷰 등록</button>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />

<script>
    // 별점 클릭 기능
    const stars = document.querySelectorAll('.star');
    let selectedRating = 0;

    stars.forEach(star => {
        star.addEventListener('click', () => {
            selectedRating = parseInt(star.getAttribute('data-value'));
            stars.forEach(s => s.classList.toggle('active', s.getAttribute('data-value') <= selectedRating));
        });
    });

    // 리뷰 등록 Ajax
    document.getElementById('submitReview').addEventListener('click', () => {
        const text = document.getElementById('reviewText').value.trim();
        if (selectedRating === 0) {
            alert("별점을 선택해주세요!");
            return;
        }
        if (text.length < 5) {
            alert("리뷰 내용을 5자 이상 입력해주세요.");
            return;
        }

        fetch('/reviews/save', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                bookId: ${item.bookId},
                orderedItemId: ${item.orderedItemId},
                rating: selectedRating,
                content: text
                // userId는 서버에서 Spring Security로 처리
            })
        })
            .then(res => res.text())
            .then(data => {
                if(data === 'success') {
                    alert('리뷰가 등록되었습니다.');
                    location.href = '/mypage';
                } else {
                    alert('해당 주문에 대해선 리뷰를 이미 작성하셨습니다');
                }
            });
    });
</script>

</body>
</html>
