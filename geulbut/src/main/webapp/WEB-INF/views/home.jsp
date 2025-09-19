<%--
 Created by IntelliJ IDEA.
 User: user Date: 25. 9. 9.
  Time: 오전 10:21
  To change this template use File | Settings | File Templates.
   --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
%>
<html>
<head>
    <title>추천 도서</title>
    <link rel="stylesheet" href="/css/00_common.css">
    <link rel="stylesheet" href="/css/header.css">
    <link rel="stylesheet" href="/css/home.css">

</head>
<body>
<jsp:include page="/common/header.jsp"></jsp:include>

<div class="page">
    <!-- 편집장의 선택 섹션 -->
    <section class="editor-choice-section">
        <div class="section-header">
            <h2 class="section-title" id="section-title">편집장의 선택</h2>
            <button class="play-button playing" aria-label="재생/정지"></button>
        </div>

        <!-- 편집장의 선택 컨텐츠 -->
        <div class="tab-content editor-choice active" id="editor-choice-content">
            <div class="books-grid">
                <!-- 책 카드 1 -->
                <div class="book-card">
                    <div class="book-badge recommend">추천</div>
                    <div class="book-image">
                        <img src="https://via.placeholder.com/120x160/667eea/ffffff?text=Book1" alt="빼빼 롱스타킹">
                        <div class="book-number">1</div>
                    </div>
                    <h3 class="book-title">빼빼 롱스타킹</h3>
                    <p class="book-author">아스트리드 린드그렌</p>
                    <div class="editor-comment">
                        <h4 class="comment-title">편집장의 한마디</h4>
                        <p class="comment-text">"어른이 되어 다시 읽는 몰락의 감동"</p>
                    </div>
                    <div class="book-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                    </div>
                </div>

                <!-- 책 카드 2 -->
                <div class="book-card">
                    <div class="book-badge recommend">추천</div>
                    <div class="book-image">
                        <img src="https://via.placeholder.com/120x160/764ba2/ffffff?text=Book2" alt="헬바운드 하트">
                        <div class="book-number">2</div>
                    </div>
                    <h3 class="book-title">헬바운드 하트</h3>
                    <p class="book-author">클라이브 바커</p>
                    <div class="editor-comment">
                        <h4 class="comment-title">편집장의 한마디</h4>
                        <p class="comment-text">"공포소설의 새로운 경지를 여는 작품"</p>
                    </div>
                    <div class="book-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                    </div>
                </div>

                <!-- 책 카드 3 -->
                <div class="book-card">
                    <div class="book-badge recommend">추천</div>
                    <div class="book-image">
                        <img src="https://via.placeholder.com/120x160/f093fb/ffffff?text=Book3" alt="이타미 준 나의 건축">
                        <div class="book-number">3</div>
                    </div>
                    <h3 class="book-title">이타미 준 나의 건축</h3>
                    <p class="book-author">이타미 준</p>
                    <div class="editor-comment">
                        <h4 class="comment-title">편집장의 한마디</h4>
                        <p class="comment-text">"건축과 철학이 만나는 아름다운 순간"</p>
                    </div>
                    <div class="book-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                    </div>
                </div>

                <!-- 책 카드 4 -->
                <div class="book-card">
                    <div class="book-badge recommend">추천</div>
                    <div class="book-image">
                        <img src="https://via.placeholder.com/120x160/4facfe/ffffff?text=Book4" alt="롤랑 바르트가 쓴 롤랑 바르트">
                        <div class="book-number">4</div>
                    </div>
                    <h3 class="book-title">롤랑 바르트가 쓴 롤랑 바르트</h3>
                    <p class="book-author">롤랑 바르트</p>
                    <div class="editor-comment">
                        <h4 class="comment-title">편집장의 한마디</h4>
                        <p class="comment-text">"현대 비평의 거장의 자기를 돌아보다"</p>
                    </div>
                    <div class="book-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 신간 소개 컨텐츠 -->
        <div class="tab-content" id="new-books-content">
            <div class="new-books-grid">
                <!-- 신간 카드 1 -->
                <div class="new-book-card">
                    <div class="new-book-badge">NEW</div>
                    <div class="new-book-image">
                        <img src="https://via.placeholder.com/250x330/667eea/ffffff?text=특별한+편의점+3" alt="특별한 편의점 3">
                    </div>
                    <h3 class="new-book-title">특별한 편의점 3</h3>
                    <p class="new-book-author">김충연</p>
                    <div class="new-book-date">📅 2024.09.15</div>
                    <p class="new-book-description">특별한 이야기 시리즈 완결편</p>
                    <button class="new-book-button">예약구매</button>
                </div>

                <!-- 신간 카드 2 -->
                <div class="new-book-card">
                    <div class="new-book-badge">NEW</div>
                    <div class="new-book-image">
                        <img src="https://via.placeholder.com/250x330/764ba2/ffffff?text=7년의+밤" alt="7년의 밤">
                    </div>
                    <h3 class="new-book-title">7년의 밤</h3>
                    <p class="new-book-author">정유정</p>
                    <div class="new-book-date">📅 2024.09.20</div>
                    <p class="new-book-description">스릴 넘치는 새로운 장편</p>
                    <button class="new-book-button">예약구매</button>
                </div>

                <!-- 신간 카드 3 -->
                <div class="new-book-card">
                    <div class="new-book-badge">NEW</div>
                    <div class="new-book-image">
                        <img src="https://via.placeholder.com/250x330/f093fb/ffffff?text=우리가+빛의+속도로+갈+수+없다면" alt="우리가 빛의 속도로 갈 수 없다면">
                    </div>
                    <h3 class="new-book-title">우리가 빛의 속도로 갈 수 없다면</h3>
                    <p class="new-book-author">김초엽</p>
                    <div class="new-book-date">📅 2024.09.25</div>
                    <p class="new-book-description">SF 소설의 새로운 차원을 연 작품</p>
                    <button class="new-book-button">예약구매</button>
                </div>

                <!-- 신간 카드 4 -->
                <div class="new-book-card">
                    <div class="new-book-badge">NEW</div>
                    <div class="new-book-image">
                        <img src="https://via.placeholder.com/250x330/4facfe/ffffff?text=완전한+행복" alt="완전한 행복">
                    </div>
                    <h3 class="new-book-title">완전한 행복</h3>
                    <p class="new-book-author">정유정</p>
                    <div class="new-book-date">📅 2024.09.30</div>
                    <p class="new-book-description">심리 스릴러의 완성형</p>
                    <button class="new-book-button">예약구매</button>
                </div>
            </div>
        </div>

        <!-- 화제의 책 컨텐츠 -->
        <div class="tab-content" id="trending-content">
            <div class="trending-grid">
                <!-- 화제의 책 카드 1 -->
                <div class="trending-card">
                    <div class="trending-badge hot">HOT</div>
                    <div class="trending-image">
                        <img src="https://via.placeholder.com/130x170/ff6b6b/ffffff?text=Trending1" alt="지금 뜨는 소설">
                        <div class="trending-rank">1</div>
                    </div>
                    <h3 class="trending-title">지금 뜨는 소설</h3>
                    <p class="trending-author">인기작가</p>
                    <div class="trending-stats">
                        <h4 class="stats-title">화제 지수</h4>
                        <div class="stats-info">
                            <div class="stats-views">🔥 15.2K 언급</div>
                            <div class="stats-trend">↗ 250%</div>
                        </div>
                    </div>
                    <div class="trending-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="rating-number">(4.7)</span>
                    </div>
                </div>

                <!-- 화제의 책 카드 2 -->
                <div class="trending-card">
                    <div class="trending-badge viral">VIRAL</div>
                    <div class="trending-image">
                        <img src="https://via.placeholder.com/130x170/764ba2/ffffff?text=Trending2" alt="SNS 화제작">
                        <div class="trending-rank">2</div>
                    </div>
                    <h3 class="trending-title">SNS 화제작</h3>
                    <p class="trending-author">바이럴 작가</p>
                    <div class="trending-stats">
                        <h4 class="stats-title">화제 지수</h4>
                        <div class="stats-info">
                            <div class="stats-views">📱 12.8K 공유</div>
                            <div class="stats-trend">↗ 320%</div>
                        </div>
                    </div>
                    <div class="trending-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="rating-number">(4.6)</span>
                    </div>
                </div>

                <!-- 화제의 책 카드 3 -->
                <div class="trending-card">
                    <div class="trending-badge rising">상승</div>
                    <div class="trending-image">
                        <img src="https://via.placeholder.com/130x170/f093fb/ffffff?text=Trending3" alt="급상승 에세이">
                        <div class="trending-rank">3</div>
                    </div>
                    <h3 class="trending-title">급상승 에세이</h3>
                    <p class="trending-author">트렌드 작가</p>
                    <div class="trending-stats">
                        <h4 class="stats-title">화제 지수</h4>
                        <div class="stats-info">
                            <div class="stats-views">💬 9.5K 댓글</div>
                            <div class="stats-trend">↗ 180%</div>
                        </div>
                    </div>
                    <div class="trending-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="rating-number">(4.8)</span>
                    </div>
                </div>

                <!-- 화제의 책 카드 4 -->
                <div class="trending-card">
                    <div class="trending-badge hot">인기</div>
                    <div class="trending-image">
                        <img src="https://via.placeholder.com/130x170/4facfe/ffffff?text=Trending4" alt="논란의 작품">
                        <div class="trending-rank">4</div>
                    </div>
                    <h3 class="trending-title">논란의 작품</h3>
                    <p class="trending-author">논쟁 작가</p>
                    <div class="trending-stats">
                        <h4 class="stats-title">화제 지수</h4>
                        <div class="stats-info">
                            <div class="stats-views">⚡ 18.7K 토론</div>
                            <div class="stats-trend">↗ 400%</div>
                        </div>
                    </div>
                    <div class="trending-rating">
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="star">★</span>
                        <span class="rating-number">(4.5)</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 지금 핫딜중 컨텐츠 -->
        <div class="tab-content" id="hotdeal-content">
            <div class="hotdeal-grid">
                <!-- 핫딜 카드 1 -->
                <div class="hotdeal-card">
                    <div class="hotdeal-badge discount-30">30% OFF</div>
                    <div class="hotdeal-image">
                        <img src="https://via.placeholder.com/200x180/4facfe/ffffff?text=설민석의+조선왕조실록" alt="설민석의 조선왕조실록">
                    </div>
                    <h3 class="hotdeal-title">설민석의 조선왕조실록</h3>
                    <p class="hotdeal-author">설민석</p>
                    <div class="hotdeal-prices">
                        <span class="original-price">22,000원</span>
                        <span class="sale-price">15,400원</span>
                    </div>
                    <div class="hotdeal-time">⏰ 5일 8시간</div>
                    <button class="hotdeal-button">구매하기</button>
                </div>

                <!-- 핫딜 카드 2 -->
                <div class="hotdeal-card">
                    <div class="hotdeal-badge discount-30">30% OFF</div>
                    <div class="hotdeal-image">
                        <img src="https://via.placeholder.com/200x180/f093fb/ffffff?text=하마터면+열심히+살+뻔했다" alt="하마터면 열심히 살 뻔했다">
                    </div>
                    <h3 class="hotdeal-title">하마터면 열심히 살 뻔했다</h3>
                    <p class="hotdeal-author">하완</p>
                    <div class="hotdeal-prices">
                        <span class="original-price">16,000원</span>
                        <span class="sale-price">11,200원</span>
                    </div>
                    <div class="hotdeal-time">⏰ 3일 12시간</div>
                    <button class="hotdeal-button">구매하기</button>
                </div>

                <!-- 핫딜 카드 3 -->
                <div class="hotdeal-card">
                    <div class="hotdeal-badge discount-30">30% OFF</div>
                    <div class="hotdeal-image">
                        <img src="https://via.placeholder.com/200x180/667eea/ffffff?text=재식주의자" alt="재식주의자">
                    </div>
                    <h3 class="hotdeal-title">재식주의자</h3>
                    <p class="hotdeal-author">한강</p>
                    <div class="hotdeal-prices">
                        <span class="original-price">15,000원</span>
                        <span class="sale-price">10,500원</span>
                    </div>
                    <div class="hotdeal-time">⏰ 2일 23시간</div>
                    <button class="hotdeal-button">구매하기</button>
                </div>

                <!-- 핫딜 카드 4 -->
                <div class="hotdeal-card">
                    <div class="hotdeal-badge discount-30">30% OFF</div>
                    <div class="hotdeal-image">
                        <img src="https://via.placeholder.com/200x180/764ba2/ffffff?text=물끓일의+시절" alt="물끓일의 시절">
                    </div>
                    <h3 class="hotdeal-title">물끓일의 시절</h3>
                    <p class="hotdeal-author">김은주</p>
                    <div class="hotdeal-prices">
                        <span class="original-price">18,000원</span>
                        <span class="sale-price">12,600원</span>
                    </div>
                    <div class="hotdeal-time">⏰ 1일 15시간</div>
                    <button class="hotdeal-button">구매하기</button>
                </div>
            </div>
        </div>

        <!-- 추천 이벤트 컨텐츠 -->
        <div class="tab-content" id="event-content">
            <div class="event-grid">
                <!-- 이벤트 카드 1 -->
                <div class="event-card">
                    <div class="event-image">
                        <img src="https://via.placeholder.com/100x100/667eea/ffffff?text=Event1" alt="감영하 작가 싸인회">
                    </div>
                    <div class="event-details">
                        <h3 class="event-title">감영하 작가 싸인회</h3>
                        <div class="event-info">
                            <div class="event-date">📅 2024년 9월 21일</div>
                            <div class="event-location">📍 고복문고 광화문점</div>
                            <div class="event-time">🕐 오후 2시</div>
                        </div>
                    </div>
                </div>

                <!-- 이벤트 카드 2 -->
                <div class="event-card">
                    <div class="event-image">
                        <img src="https://via.placeholder.com/100x100/764ba2/ffffff?text=Event2" alt="독서모임 '책과 함께'">
                    </div>
                    <div class="event-details">
                        <h3 class="event-title">독서모임 '책과 함께'</h3>
                        <div class="event-info">
                            <div class="event-date">📅 매주 토요일</div>
                            <div class="event-location">📍 양라단 서점 홍대점</div>
                            <div class="event-time">🕐 오후 7시</div>
                        </div>
                    </div>
                </div>

                <!-- 이벤트 카드 3 -->
                <div class="event-card">
                    <div class="event-image">
                        <img src="https://via.placeholder.com/100x100/f093fb/ffffff?text=Event3" alt="신간 출간기념 북토크">
                    </div>
                    <div class="event-details">
                        <h3 class="event-title">신간 출간기념 북토크</h3>
                        <div class="event-info">
                            <div class="event-date">📅 2024년 9월 25일</div>
                            <div class="event-location">📍 온라인 라이브</div>
                            <div class="event-time">🕐 오후 8시</div>
                        </div>
                    </div>
                </div>

                <!-- 이벤트 카드 4 -->
                <div class="event-card">
                    <div class="event-image">
                        <img src="https://via.placeholder.com/100x100/4facfe/ffffff?text=Event4" alt="출리소설 토론회">
                    </div>
                    <div class="event-details">
                        <h3 class="event-title">출리소설 토론회</h3>
                        <div class="event-info">
                            <div class="event-date">📅 2024년 9월 30일</div>
                            <div class="event-location">📍 YES24 강남점</div>
                            <div class="event-time">🕐 오후 3시</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 이벤트 굿즈 컨텐츠 -->
        <div class="tab-content" id="goods-content">
            <div class="goods-grid">
                <!-- 굿즈 카드 1 -->
                <div class="goods-card">
                    <div class="goods-badge special">한정</div>
                    <div class="goods-image">
                        <img src="https://via.placeholder.com/200x200/ff6b6b/ffffff?text=Goods1" alt="북페딘 감성우산">
                    </div>
                    <div class="goods-info">
                        <h3 class="goods-title">북페딘 감성우산</h3>
                        <div class="goods-period">📅 2025.01.15 ~ 2025.02.28</div>
                        <div class="goods-publisher">지금출간: 첫 구매</div>
                        <div class="goods-author">분야: 패션</div>
                        <div class="goods-price">
                            <span class="current-price">29,000원</span>
                            <span class="discount">35% 할인</span>
                        </div>
                    </div>
                </div>

                <!-- 굿즈 카드 2 -->
                <div class="goods-card">
                    <div class="goods-badge new">NEW</div>
                    <div class="goods-image">
                        <img src="https://via.placeholder.com/200x200/764ba2/ffffff?text=Goods2" alt="달빛 무드등">
                    </div>
                    <div class="goods-info">
                        <h3 class="goods-title">달빛 무드등</h3>
                        <div class="goods-period">📅 2025.01.20 ~ 2025.03.15</div>
                        <div class="goods-publisher">지금출간: 회독가입</div>
                        <div class="goods-author">분야: 인테리어</div>
                        <div class="goods-price">
                            <span class="current-price">42,000원</span>
                            <span class="discount">30% 할인</span>
                        </div>
                    </div>
                </div>

                <!-- 굿즈 카드 3 -->
                <div class="goods-card">
                    <div class="goods-badge hot">HOT</div>
                    <div class="goods-image">
                        <img src="https://via.placeholder.com/200x200/4facfe/ffffff?text=Goods3" alt="도서관 향 캔들">
                    </div>
                    <div class="goods-info">
                        <h3 class="goods-title">도서관 향 캔들</h3>
                        <div class="goods-period">📅 2025.01.10 ~ 2025.02.20</div>
                        <div class="goods-publisher">지금출간: 리뷰작성</div>
                        <div class="goods-author">분야: 라이프</div>
                        <div class="goods-price">
                            <span class="current-price">18,000원</span>
                            <span class="discount">25% 할인</span>
                        </div>
                    </div>
                </div>

                <!-- 굿즈 카드 4 -->
                <div class="goods-card">
                    <div class="goods-badge best">BEST</div>
                    <div class="goods-image">
                        <img src="https://via.placeholder.com/200x200/f093fb/ffffff?text=Goods4" alt="독서 블루라이트 안경">
                    </div>
                    <div class="goods-info">
                        <h3 class="goods-title">독서 블루라이트 안경</h3>
                        <div class="goods-period">📅 2025.01.25 ~ 2025.03.10</div>
                        <div class="goods-publisher">지금출간: 멤십자</div>
                        <div class="goods-author">분야: 헬스케어</div>
                        <div class="goods-price">
                            <span class="current-price">33,000원</span>
                            <span class="discount">40% 할인</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 이 주의 책 컨텐츠 -->
        <div class="tab-content" id="weekly-content">
            <div class="weekly-grid">
                <!-- 주간 추천 책 1 -->
                <div class="weekly-card">
                    <div class="weekly-badge">이주의책</div>
                    <div class="weekly-image">
                        <img src="https://via.placeholder.com/180x240/667eea/ffffff?text=Book1" alt="소년이 온다">
                    </div>
                    <div class="weekly-info">
                        <h3 class="weekly-title">소년이 온다</h3>
                        <p class="weekly-author">한강</p>
                        <div class="weekly-rating">
                            <span class="star">⭐</span>
                            <span class="rating-score">4.8</span>
                            <span class="rating-text">평점</span>
                        </div>
                        <div class="weekly-comment">
                            <p class="comment-text">이주의 편집장 추천! 깊은 감동을 주는 작품</p>
                        </div>
                    </div>
                </div>

                <!-- 주간 추천 책 2 -->
                <div class="weekly-card">
                    <div class="weekly-badge">이주의책</div>
                    <div class="weekly-image">
                        <img src="https://via.placeholder.com/180x240/764ba2/ffffff?text=Book2" alt="82년생 김지영">
                    </div>
                    <div class="weekly-info">
                        <h3 class="weekly-title">82년생 김지영</h3>
                        <p class="weekly-author">조남주</p>
                        <div class="weekly-rating">
                            <span class="star">⭐</span>
                            <span class="rating-score">4.6</span>
                            <span class="rating-text">평점</span>
                        </div>
                        <div class="weekly-comment">
                            <p class="comment-text">사회 현상을 날카롭게 다룬 화제작</p>
                        </div>
                    </div>
                </div>

                <!-- 주간 추천 책 3 -->
                <div class="weekly-card">
                    <div class="weekly-badge">이주의책</div>
                    <div class="weekly-image">
                        <img src="https://via.placeholder.com/180x240/4facfe/ffffff?text=Book3" alt="미드나잇 라이브러리">
                    </div>
                    <div class="weekly-info">
                        <h3 class="weekly-title">미드나잇 라이브러리</h3>
                        <p class="weekly-author">매트 헤이그</p>
                        <div class="weekly-rating">
                            <span class="star">⭐</span>
                            <span class="rating-score">4.7</span>
                            <span class="rating-text">평점</span>
                        </div>
                        <div class="weekly-comment">
                            <p class="comment-text">인생의 선택에 대한 철학적 사유</p>
                        </div>
                    </div>
                </div>

                <!-- 주간 추천 책 4 -->
                <div class="weekly-card">
                    <div class="weekly-badge">이주의책</div>
                    <div class="weekly-image">
                        <img src="https://via.placeholder.com/180x240/f093fb/ffffff?text=Book4" alt="작별하지 않는다">
                    </div>
                    <div class="weekly-info">
                        <h3 class="weekly-title">작별하지 않는다</h3>
                        <p class="weekly-author">한강</p>
                        <div class="weekly-rating">
                            <span class="star">⭐</span>
                            <span class="rating-score">4.9</span>
                            <span class="rating-text">평점</span>
                        </div>
                        <div class="weekly-comment">
                            <p class="comment-text">노벨문학상 수상작가의 최신작</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 탭 메뉴 -->
        <div class="tab-menu">
            <button class="tab-item active" onclick="showTab('editor-choice-content', '편집장의 선택')">편집장의 선택</button>
            <button class="tab-item" onclick="showTab('new-books-content', '추천 이벤트')">추천 이벤트</button>
            <button class="tab-item" onclick="showTab('trending-content', '이 주의 책')">이 주의 책</button>
            <button class="tab-item" onclick="showTab('hotdeal-content', '신간 소개')">신간 소개</button>
            <button class="tab-item" onclick="showTab('event-content', '화제의 책')">화제의 책</button>
            <button class="tab-item" onclick="showTab('goods-content', '이벤트 굿즈')">이벤트 굿즈</button>
            <button class="tab-item" onclick="showTab('weekly-content', '지금 핫딜중')">지금 핫딜중</button>
        </div>
    </section>

    <!-- 광고창 -->
    <section class="ad-marquee">
        <div class="marquee-content">
            📢 특별 할인! 9월 한정, 인기 도서 최대 30% 할인 중! 🎁 | 신규 회원은 첫 구매 시 추가 쿠폰 지급! ✨ | 이번 주 이벤트: 베스트셀러 1+1!
        </div>
    </section>

    <!-- 아이콘 메뉴 -->
    <section class="icon-menu">
        <div class="icon-menu-grid">
            <a href="/gift" class="icon-item gift">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e53e3e" stroke-width="2">
                        <polyline points="20,12 20,19 4,19 4,12"></polyline>
                        <rect x="2" y="5" width="20" height="7"></rect>
                        <line x1="12" y1="22" x2="12" y2="5"></line>
                        <path d="m9,5 A3,3 0 0,1 6,2 A3,3 0 0,1 9,5 m6,0 A3,3 0 0,0 18,2 A3,3 0 0,0 15,5"></path>
                    </svg>
                </div>
                <span class="icon-label">기프트카드</span>
            </a>
            <a href="/discount" class="icon-item discount">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#38a169" stroke-width="2">
                        <circle cx="8" cy="8" r="6"></circle>
                        <path d="m18.09 10.37 1.51 1.51c.39.39.39 1.02 0 1.41l-8.94 8.94c-.39.39-1.02.39-1.41 0l-1.51-1.51"></path>
                        <path d="m8 8 6 6"></path>
                        <path d="m7 7h.01"></path>
                        <path d="m17 17h.01"></path>
                    </svg>
                </div>
                <span class="icon-label">할인혜택</span>
            </a>
            <a href="/event" class="icon-item event">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#d69e2e" stroke-width="2">
                        <path d="M9 11H3v8h6m11-8h-6v8h6m-7-14v8m-5-5 5 5 5-5"></path>
                    </svg>
                </div>
                <span class="icon-label">이벤트</span>
            </a>
            <a href="/bestseller" class="icon-item bestseller">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3182ce" stroke-width="2">
                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                    </svg>
                </div>
                <span class="icon-label">베스트셀러</span>
            </a>
            <a href="/review" class="icon-item review">
                <div class="icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#805ad5" stroke-width="2">
                        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                        <path d="M8 9h8"></path>
                        <path d="M8 13h6"></path>
                    </svg>
                </div>
                <span class="icon-label">리뷰·추천</span>
            </a>
        </div>
    </section>

    <!-- 이달의 주목도서 -->
    <section class="featured-books">
        <div class="featured-header">
            <div class="featured-title-area">
                <div class="bookmark-icon">📑</div>
                <div class="featured-title-text">
                    <h2 class="featured-main-title">이달의 주목도서</h2>
                    <p class="featured-subtitle">편집부가 엄선한 9월의 추천 도서</p>
                </div>
            </div>
            <div class="hot-indicator">🔥 Hot 5</div>
        </div>

        <div class="featured-books-grid">
            <!-- 추천 도서 카드 1 -->
            <div class="featured-book-card">
                <div class="book-info-top">
                    <div class="discount-badge">10%</div>
                    <div class="category-tag">육아 베스트</div>
                </div>
                <div class="featured-book-image">
                    <img src="https://via.placeholder.com/160x220/ff6b6b/ffffff?text=부모의+태도가" alt="부모의 태도가 아이의 불안이 되지 않게">
                </div>
                <div class="featured-book-info">
                    <h3 class="featured-book-title">부모의 태도가 아이의 불안이 되지 않게</h3>
                    <p class="featured-book-author">예슬</p>
                    <div class="book-rating">
                        <span class="stars">★ 4.8</span>
                        <span class="review-count">(115)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">14,400원</span>
                        <span class="original-price">16,000원</span>
                    </div>
                    <p class="book-description">아이와의 건강한 소통법을 배울 수 있어요</p>
                    <button class="detail-button">자세히 보기</button>
                </div>
            </div>

            <!-- 추천 도서 카드 2 -->
            <div class="featured-book-card">
                <div class="book-info-top">
                    <div class="discount-badge">10%</div>
                    <div class="category-tag">화제의 신간</div>
                </div>
                <div class="featured-book-image">
                    <img src="https://via.placeholder.com/160x220/4ecdc4/ffffff?text=행운음원" alt="행운음원">
                </div>
                <div class="featured-book-info">
                    <h3 class="featured-book-title">행운음원</h3>
                    <p class="featured-book-author">차상동</p>
                    <div class="book-rating">
                        <span class="stars">★ 4.6</span>
                        <span class="review-count">(592)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">13,500원</span>
                        <span class="original-price">15,000원</span>
                    </div>
                    <p class="book-description">음악과 인생이 만나는 감동적인 이야기</p>
                    <button class="detail-button">자세히 보기</button>
                </div>
            </div>

            <!-- 추천 도서 카드 3 -->
            <div class="featured-book-card">
                <div class="book-info-top">
                    <div class="discount-badge">20%</div>
                    <div class="category-tag">사회적 고전</div>
                </div>
                <div class="featured-book-image">
                    <img src="https://via.placeholder.com/160x220/45b7d1/ffffff?text=화이트칼라" alt="화이트칼라">
                </div>
                <div class="featured-book-info">
                    <h3 class="featured-book-title">화이트칼라</h3>
                    <p class="featured-book-author">찰스 라이트 밀스</p>
                    <div class="book-rating">
                        <span class="stars">★ 4.9</span>
                        <span class="review-count">(515)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">14,400원</span>
                        <span class="original-price">18,000원</span>
                    </div>
                    <p class="book-description">현대 사회의 중산층을 날카롭게 분석한 명작</p>
                    <button class="detail-button">자세히 보기</button>
                </div>
            </div>

            <!-- 추천 도서 카드 4 -->
            <div class="featured-book-card">
                <div class="book-info-top">
                    <div class="discount-badge">10%</div>
                    <div class="category-tag">AI 트렌드</div>
                </div>
                <div class="featured-book-image">
                    <img src="https://via.placeholder.com/160x220/f9ca24/ffffff?text=AGI" alt="AGI, 천사인가 악마인가">
                </div>
                <div class="featured-book-info">
                    <h3 class="featured-book-title">AGI, 천사인가 악마인가</h3>
                    <p class="featured-book-author">김대식</p>
                    <div class="book-rating">
                        <span class="stars">★ 4.7</span>
                        <span class="review-count">(275)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">15,300원</span>
                        <span class="original-price">17,000원</span>
                    </div>
                    <p class="book-description">인공지능의 미래를 통찰한 있는 예측</p>
                    <button class="detail-button">자세히 보기</button>
                </div>
            </div>

            <!-- 추천 도서 카드 5 -->
            <div class="featured-book-card">
                <div class="book-info-top">
                    <div class="discount-badge">10%</div>
                    <div class="category-tag">시험 추천</div>
                </div>
                <div class="featured-book-image">
                    <img src="https://via.placeholder.com/160x220/6c5ce7/ffffff?text=말뚝들" alt="말뚝들">
                </div>
                <div class="featured-book-info">
                    <h3 class="featured-book-title">말뚝들</h3>
                    <p class="featured-book-author">김홍</p>
                    <div class="book-rating">
                        <span class="stars">★ 4.5</span>
                        <span class="review-count">(546)</span>
                    </div>
                    <div class="book-price">
                        <span class="current-price">12,600원</span>
                        <span class="original-price">14,000원</span>
                    </div>
                    <p class="book-description">깊이 있는 성찰과 철학이 담긴 시집</p>
                    <button class="detail-button">자세히 보기</button>
                </div>
            </div>
        </div>

        <div class="view-all-link">
            <a href="/featured-books">⏰ 이달의 추천도서 전체보기</a>
        </div>
    </section>

    <!-- 어제 베스트셀러 TOP 10 -->
    <section class="bestseller-section">
        <h2 class="bestseller-title">어제 베스트셀러 TOP 10</h2>
        <div class="bestseller-grid">
            <!-- 1위 -->
            <div class="bestseller-item">
                <div class="rank-number rank-1">1</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/ffd700/000000?text=혼한남매20" alt="혼한남매 20">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">혼한남매 20</h3>
                        <span class="bestseller-badge new">NEW</span>
                    </div>
                    <p class="bestseller-author">글 • 그림</p>
                </div>
            </div>

            <!-- 2위 -->
            <div class="bestseller-item">
                <div class="rank-number rank-2">2</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/c0c0c0/000000?text=절창" alt="절창">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">절창</h3>
                        <span class="bestseller-badge down">▼1</span>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>

            <!-- 3위 -->
            <div class="bestseller-item">
                <div class="rank-number rank-3">3</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/cd7f32/ffffff?text=호의에대하여" alt="호의에 대하여">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">호의에 대하여</h3>
                        <span class="bestseller-badge up">▲2</span>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>

            <!-- 4위 -->
            <div class="bestseller-item">
                <div class="rank-number">4</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/667eea/ffffff?text=텟템이론" alt="텟템 이론">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">텟템 이론</h3>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>

            <!-- 5위 -->
            <div class="bestseller-item">
                <div class="rank-number">5</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/764ba2/ffffff?text=혼모노" alt="혼모노">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">혼모노</h3>
                        <span class="bestseller-badge up">▲1</span>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>

            <!-- 6위 -->
            <div class="bestseller-item">
                <div class="rank-number">6</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/f093fb/ffffff?text=천국대마경11" alt="천국대마경 11">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">천국대마경 11</h3>
                        <span class="bestseller-badge new">NEW</span>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>

            <!-- 7위 -->
            <div class="bestseller-item">
                <div class="rank-number">7</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/4facfe/ffffff?text=천국대마경가이드" alt="천국대마경 공식 코믹 가이드">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">천국대마경 공식 코믹 가이드</h3>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>

            <!-- 8위 -->
            <div class="bestseller-item">
                <div class="rank-number">8</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/ff6b6b/ffffff?text=노인과바다" alt="노인과 바다 (멘슬리 클래식)">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">노인과 바다 (멘슬리 클래식)</h3>
                        <span class="bestseller-badge down">▼5</span>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>

            <!-- 9위 -->
            <div class="bestseller-item">
                <div class="rank-number">9</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/4ecdc4/ffffff?text=양명의조개껍데기" alt="양명의 조개껍데기">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">양명의 조개껍데기</h3>
                        <span class="bestseller-badge up">▲4</span>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>

            <!-- 10위 -->
            <div class="bestseller-item">
                <div class="rank-number">10</div>
                <img class="bestseller-thumb" src="https://via.placeholder.com/60x80/45b7d1/ffffff?text=2025큰별쌤" alt="2025 큰별쌤 최태성의 별★...">
                <div class="bestseller-info">
                    <div class="bestseller-title-line">
                        <h3 class="bestseller-book-title">2025 큰별쌤 최태성의 별★...</h3>
                        <span class="bestseller-badge down">▼8</span>
                    </div>
                    <p class="bestseller-author">저자 예시</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 전폭 슬라이더 광고 배너 -->
    <!-- 큰 도서 광고창 -->
    <section class="slider-ad-container">
        <div class="slider-ad">
            <button class="slider-nav prev" onclick="prevBanner()">‹</button>
            <button class="slider-nav next" onclick="nextBanner()">›</button>
            <div class="slider-track" id="sliderTrack">
                <div class="slider-item">
                    <div class="slider-content">
                        <h2 class="slider-title">🍂 가을 독서 페스티벌 🍂</h2>
                        <p class="slider-subtitle">9월 한정! 모든 문학도서 25% 할인 + 무료배송</p>
                        <a href="/autumn-event" class="slider-button">지금 구매하기</a>
                    </div>
                </div>
                <div class="slider-item">
                    <div class="slider-content">
                        <h2 class="slider-title">✨ VIP 멤버십 특가 ✨</h2>
                        <p class="slider-subtitle">프리미엄 회원 가입시 전자책 무제한 이용권 증정!</p>
                        <a href="/membership" class="slider-button">멤버십 가입</a>
                    </div>
                </div>
                <div class="slider-item">
                    <div class="slider-content">
                        <h2 class="slider-title">🔥 이달의 신간 베스트 🔥</h2>
                        <p class="slider-subtitle">화제의 신간도서 예약 주문시 15% 할인 + 굿즈 증정</p>
                        <a href="/new-books" class="slider-button">신간 보러가기</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 화제의 책 소식 섹션 -->
    <section class="hot-news-section">
        <h2 class="hot-news-title">화제의 책 소식</h2>

        <div class="hot-news-slider">
            <div class="hot-news-container">
                <!-- 페이지 1 -->
                <div class="hot-news-page active">
                    <div class="hot-news-grid">
                        <!-- 책 카드 1 -->
                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-1">#1</span>
                                <span class="status-badge hot">HOT</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/ff6b6b/ffffff?text=달러구트+꿈+백화점" alt="달러구트 꿈 백화점">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">달러구트 꿈 백화점</h3>
                                <p class="book-author">이미예</p>
                                <p class="book-description">꿈을 파는 신비한 백화점에서 벌어지는 따뜻한 이야기</p>
                                <p class="book-genre">판타지</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.8</span>
                                </div>
                                <div class="book-price">13,500원</div>
                                <div class="book-stats">
                                    <span class="views">💬 15,847회</span>
                                    <span class="likes">👁 52,672</span>
                                    <span class="hearts">❤ 4,248</span>
                                </div>
                            </div>
                        </div>

                        <!-- 책 카드 2 -->
                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-2">#2</span>
                                <span class="status-badge best">BEST</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/4ecdc4/ffffff?text=지구+끝의+온실" alt="지구 끝의 온실">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">지구 끝의 온실</h3>
                                <p class="book-author">김초엽</p>
                                <p class="book-description">기후 변화와 인간의 미래를 그린 SF 걸작</p>
                                <p class="book-genre">SF소설</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.9</span>
                                </div>
                                <div class="book-price">16,200원</div>
                                <div class="book-stats">
                                    <span class="views">💬 12,632회</span>
                                    <span class="likes">👁 41,941</span>
                                    <span class="hearts">❤ 3,756</span>
                                </div>
                            </div>
                        </div>

                        <!-- 책 카드 3 -->
                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-3">#3</span>
                                <span class="status-badge new">NEW</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/6c5ce7/ffffff?text=보건교사+안은영" alt="보건교사 안은영">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">보건교사 안은영</h3>
                                <p class="book-author">정세랑</p>
                                <p class="book-description">학교에서 벌어지는 기묘하고 따뜻한 이야기</p>
                                <p class="book-genre">환상소설</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.6</span>
                                </div>
                                <div class="book-price">14,400원</div>
                                <div class="book-stats">
                                    <span class="views">💬 9,284회</span>
                                    <span class="likes">👁 31,117</span>
                                    <span class="hearts">❤ 2,942</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 페이지 2 -->
                <div class="hot-news-page">
                    <div class="hot-news-grid">
                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-4">#4</span>
                                <span class="status-badge trending">인기</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/f093fb/ffffff?text=트렌드+코리아+2025" alt="트렌드 코리아 2025">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">트렌드 코리아 2025</h3>
                                <p class="book-author">김난도</p>
                                <p class="book-description">2025년을 이끌어갈 소비 트렌드 분석서</p>
                                <p class="book-genre">경제/경영</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.7</span>
                                </div>
                                <div class="book-price">17,100원</div>
                                <div class="book-stats">
                                    <span class="views">💬 11,456회</span>
                                    <span class="likes">👁 38,891</span>
                                    <span class="hearts">❤ 3,134</span>
                                </div>
                            </div>
                        </div>

                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-5">#5</span>
                                <span class="status-badge hot">HOT</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/45b7d1/ffffff?text=불편한+편의점" alt="불편한 편의점">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">불편한 편의점</h3>
                                <p class="book-author">김호연</p>
                                <p class="book-description">청파동 골목길 편의점에서 펼쳐지는 인생 드라마</p>
                                <p class="book-genre">소설</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.5</span>
                                </div>
                                <div class="book-price">13,950원</div>
                                <div class="book-stats">
                                    <span class="views">💬 8,789회</span>
                                    <span class="likes">👁 29,456</span>
                                    <span class="hearts">❤ 2,876</span>
                                </div>
                            </div>
                        </div>

                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-6">#6</span>
                                <span class="status-badge best">BEST</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/ff9ff3/ffffff?text=아몬드" alt="아몬드">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">아몬드</h3>
                                <p class="book-author">손원평</p>
                                <p class="book-description">감정을 느끼지 못하는 소년의 성장 이야기</p>
                                <p class="book-genre">청소년소설</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.4</span>
                                </div>
                                <div class="book-price">12,600원</div>
                                <div class="book-stats">
                                    <span class="views">💬 7,432회</span>
                                    <span class="likes">👁 25,876</span>
                                    <span class="hearts">❤ 2,567</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 페이지 3 -->
                <div class="hot-news-page">
                    <div class="hot-news-grid">
                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-7">#7</span>
                                <span class="status-badge new">NEW</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/54a0ff/ffffff?text=미드나잇+라이브러리" alt="미드나잇 라이브러리">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">미드나잇 라이브러리</h3>
                                <p class="book-author">매트 헤이그</p>
                                <p class="book-description">인생의 다른 선택들을 경험해 수 있는 신비한 도서관 이야기</p>
                                <p class="book-genre">현대문학</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.9</span>
                                </div>
                                <div class="book-price">16,500원</div>
                                <div class="book-stats">
                                    <span class="views">💬 11,203회</span>
                                    <span class="likes">👁 42,815</span>
                                    <span class="hearts">❤ 3,074</span>
                                </div>
                            </div>
                        </div>

                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-8">#8</span>
                                <span class="status-badge trending">명작</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/ff6348/ffffff?text=언어의+온도" alt="언어의 온도">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">언어의 온도</h3>
                                <p class="book-author">이기주</p>
                                <p class="book-description">말과 글에 숨겨진 따뜻함과 자가슴에 대한 아름다운 에세이</p>
                                <p class="book-genre">에세이</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.6</span>
                                </div>
                                <div class="book-price">14,000원</div>
                                <div class="book-stats">
                                    <span class="views">💬 6,487회</span>
                                    <span class="likes">👁 25,396</span>
                                    <span class="hearts">❤ 1,639</span>
                                </div>
                            </div>
                        </div>

                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-9">#9</span>
                                <span class="status-badge hot">스테디</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/2ed573/ffffff?text=코스모스" alt="코스모스">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">코스모스</h3>
                                <p class="book-author">칼 세이건</p>
                                <p class="book-description">우주에 대한 경이로움과 과학적 탐구 정신을 담은 불멸의 명저</p>
                                <p class="book-genre">과학</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.8</span>
                                </div>
                                <div class="book-price">22,000원</div>
                                <div class="book-stats">
                                    <span class="views">💬 4,923회</span>
                                    <span class="likes">👁 18,742</span>
                                    <span class="hearts">❤ 1,256</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 페이지 4 -->
                <div class="hot-news-page">
                    <div class="hot-news-grid">
                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-10">#10</span>
                                <span class="status-badge trending">추천</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/9b59b6/ffffff?text=봄날의+서점" alt="봄날의 서점">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">봄날의 서점</h3>
                                <p class="book-author">김수연</p>
                                <p class="book-description">작은 서점에서 펼쳐지는 따뜻한 이야기들과 책을 사랑하는 사람들의 마음</p>
                                <p class="book-genre">힐링/에세이</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.7</span>
                                </div>
                                <div class="book-price">16,000원</div>
                                <div class="book-stats">
                                    <span class="views">💬 6,749회</span>
                                    <span class="likes">👁 34,856</span>
                                    <span class="hearts">❤ 2,381</span>
                                </div>
                            </div>
                        </div>

                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-11">#11</span>
                                <span class="status-badge hot">화제</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/e056fd/ffffff?text=숲속의+도서관" alt="숲속의 도서관">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">숲속의 도서관</h3>
                                <p class="book-author">박민구</p>
                                <p class="book-description">자연과 책이 어우러진 신비로운 공간에서 벌어지는 마법 같은 이야기</p>
                                <p class="book-genre">판타지</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.5</span>
                                </div>
                                <div class="book-price">17,000원</div>
                                <div class="book-stats">
                                    <span class="views">💬 5,912회</span>
                                    <span class="likes">👁 27,643</span>
                                    <span class="hearts">❤ 1,756</span>
                                </div>
                            </div>
                        </div>

                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-12">#12</span>
                                <span class="status-badge best">인기</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/ff7675/ffffff?text=달빛+카페의+비밀" alt="달빛 카페의 비밀">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">달빛 카페의 비밀</h3>
                                <p class="book-author">정유정</p>
                                <p class="book-description">밤에만 문을 여는 신비한 카페에서 일어나는 따뜻하고 신비로운 이야기들</p>
                                <p class="book-genre">로맨스/판타지</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.8</span>
                                </div>
                                <div class="book-price">19,000원</div>
                                <div class="book-stats">
                                    <span class="views">💬 8,356회</span>
                                    <span class="likes">👁 31,927</span>
                                    <span class="hearts">❤ 2,194</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 페이지 5 -->
                <div class="hot-news-page">
                    <div class="hot-news-grid">
                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-13">#13</span>
                                <span class="status-badge new">NEW</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/00cec9/ffffff?text=시간+여행자의+일기" alt="시간 여행자의 일기">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">시간 여행자의 일기</h3>
                                <p class="book-author">이상현</p>
                                <p class="book-description">과거와 현재를 넘나드는 신비한 여행과 운명적 만남의 이야기</p>
                                <p class="book-genre">SF/로맨스</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.6</span>
                                </div>
                                <div class="book-price">18,500원</div>
                                <div class="book-stats">
                                    <span class="views">💬 7,123회</span>
                                    <span class="likes">👁 28,945</span>
                                    <span class="hearts">❤ 2,067</span>
                                </div>
                            </div>
                        </div>

                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-14">#14</span>
                                <span class="status-badge trending">화제</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/fd79a8/ffffff?text=마법사의+레시피북" alt="마법사의 레시피북">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">마법사의 레시피북</h3>
                                <p class="book-author">윤서영</p>
                                <p class="book-description">요리를 통해 마법을 부리는 젊은 마법사의 성장기와 모험</p>
                                <p class="book-genre">판타지</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.4</span>
                                </div>
                                <div class="book-price">15,800원</div>
                                <div class="book-stats">
                                    <span class="views">💬 6,234회</span>
                                    <span class="likes">👁 24,678</span>
                                    <span class="hearts">❤ 1,834</span>
                                </div>
                            </div>
                        </div>

                        <div class="hot-news-card">
                            <div class="card-header">
                                <span class="rank-badge rank-15">#15</span>
                                <span class="status-badge hot">HOT</span>
                            </div>
                            <div class="book-cover">
                                <img src="https://via.placeholder.com/200x280/fdcb6e/ffffff?text=별이+빛나는+밤에" alt="별이 빛나는 밤에">
                            </div>
                            <div class="book-content">
                                <h3 class="book-title">별이 빛나는 밤에</h3>
                                <p class="book-author">강민호</p>
                                <p class="book-description">도시의 소음을 벗어나 별빛 아래에서 찾은 진정한 자신의 이야기</p>
                                <p class="book-genre">에세이</p>
                                <div class="book-rating">
                                    <span class="stars">⭐ 4.7</span>
                                </div>
                                <div class="book-price">13,200원</div>
                                <div class="book-stats">
                                    <span class="views">💬 5,487회</span>
                                    <span class="likes">👁 21,356</span>
                                    <span class="hearts">❤ 1,523</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 하단 내비게이션 -->
        <div class="bottom-navigation">
            <button class="slider-nav prev" id="prevBtn">‹이전</button>
            <div class="pagination-dots">
                <span class="dot active" data-page="0"></span>
                <span class="dot" data-page="1"></span>
                <span class="dot" data-page="2"></span>
            </div>
            <button class="slider-nav next" id="nextBtn">다음›</button>
        </div>
    </section>

    <!-- 2칸씩 있는 도서 광고창 -->
    <section class="promotion-section">
        <div class="promotion-slider">
            <!-- 슬라이더 화살표 -->
            <button class="promo-slider-btn prev" id="promoPrevBtn">></button>
            <button class="promo-slider-btn next" id="promoNextBtn">></button>

            <div class="promotion-container">
                <!-- 첫 번째 페이지 -->
                <div class="promotion-page active">
                    <div class="promotion-grid">
                        <!-- 베스트셀러 프로모션 -->
                        <div class="promotion-card bestseller-promo">
                            <div class="promo-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                                </svg>
                                <span>선간</span>
                            </div>
                            <div class="promo-content">
                                <h3 class="promo-title">베스트셀러 1위</h3>
                                <h4 class="promo-subtitle">「달러구트 꿈의 서점」, 신작 출간</h4>
                                <p class="promo-description">전국 서점가 화제! 특별 예약판매 30% 할인</p>
                                <button class="promo-button">자세히 보기 ></button>
                            </div>
                            <div class="promo-image">
                                <img src="https://via.placeholder.com/120x160/667eea/ffffff?text=달러구트+꿈의+서점" alt="달러구트 꿈의 서점">
                            </div>
                        </div>

                        <!-- MD 추천 프로모션 -->
                        <div class="promotion-card md-promo">
                            <div class="promo-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M9 11H3v8h6m11-8h-6v8h6m-7-14v8m-5-5 5 5 5-5"></path>
                                </svg>
                                <span>MD추천</span>
                            </div>
                            <div class="promo-content">
                                <h3 class="promo-title">자기계발 MD 추천</h3>
                                <h4 class="promo-subtitle">「아주 작은 습관의 힘」</h4>
                                <p class="promo-description">올해 가장 많이 읽힌 자기계발서, 리뷰 이벤트 진행 중</p>
                                <button class="promo-button">자세히 보기 ></button>
                            </div>
                            <div class="promo-image">
                                <img src="https://via.placeholder.com/120x160/f97316/ffffff?text=아주+작은+습관의+힘" alt="아주 작은 습관의 힘">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 두 번째 페이지 -->
                <div class="promotion-page">
                    <div class="promotion-grid">
                        <!-- 신간 프로모션 -->
                        <div class="promotion-card new-book-promo">
                            <div class="promo-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14,2 14,8 20,8"></polyline>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                    <polyline points="10,9 9,9 8,9"></polyline>
                                </svg>
                                <span>신간</span>
                            </div>
                            <div class="promo-content">
                                <h3 class="promo-title">9월 화제의 신간</h3>
                                <h4 class="promo-subtitle">「미드나잇 라이브러리」</h4>
                                <p class="promo-description">전 세계 독자들의 찬사! 선주문 시 한정 굿즈 증정</p>
                                <button class="promo-button">자세히 보기 ></button>
                            </div>
                            <div class="promo-image">
                                <img src="https://via.placeholder.com/120x160/10b981/ffffff?text=미드나잇+라이브러리" alt="미드나잇 라이브러리">
                            </div>
                        </div>

                        <!-- 오디오북 프로모션 -->
                        <div class="promotion-card audiobook-promo">
                            <div class="promo-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
                                    <path d="m19.07 4.93-1.4 1.4A6.5 6.5 0 0 1 19.5 12a6.5 6.5 0 0 1-1.83 5.67l1.4 1.4A8.5 8.5 0 0 0 21.5 12a8.5 8.5 0 0 0-2.43-7.07z"></path>
                                    <path d="m15.54 8.46-1.4 1.4A2.5 2.5 0 0 1 15.5 12a2.5 2.5 0 0 1-1.36 2.14l1.4 1.4A4.5 4.5 0 0 0 17.5 12a4.5 4.5 0 0 0-1.96-4.54z"></path>
                                </svg>
                                <span>오디오</span>
                            </div>
                            <div class="promo-content">
                                <h3 class="promo-title">오디오북 특가</h3>
                                <h4 class="promo-subtitle">「사피엔스」 오디오북</h4>
                                <p class="promo-description">성우 김영철 낭독! 첫 구매 고객 50% 할인 혜택</p>
                                <button class="promo-button">자세히 보기 ></button>
                            </div>
                            <div class="promo-image">
                                <img src="https://via.placeholder.com/120x160/6366f1/ffffff?text=사피엔스+오디오북" alt="사피엔스 오디오북">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="promotion-footer">
            <p class="promotion-notice">
                <span class="notice-dot">●</span>
                매주 새로운 책 프로모션, 독자 여러분을 위한 특별한 혜택
            </p>
        </div>
    </section>

    <!-- 이 주의 특가 섹션 -->
    <section class="weekly-special-section">
        <div class="special-header">
            <div class="special-title-area">
                <span class="special-icon">🏷️</span>
                <div class="special-title-text">
                    <h2 class="special-main-title">이 주의 특가</h2>
                    <p class="special-subtitle">% 최대 80% 할인</p>
                </div>
            </div>
            <a href="/special-deals" class="more-link">더보기 ></a>
        </div>

        <div class="special-books-grid">
            <!-- 특가 도서 카드 1 -->
            <div class="special-book-card">
                <div class="special-badges">
                    <div class="discount-percent">% 70%</div>
                    <div class="days-left">2일 남음</div>
                </div>
                <div class="special-book-image">
                    <img src="https://via.placeholder.com/160x220/4a5568/ffffff?text=삼각지" alt="삼각지">
                </div>
                <div class="special-book-info">
                    <div class="book-category">소설</div>
                    <h3 class="special-book-title">삼각지</h3>
                    <p class="special-book-author">이미예</p>
                    <div class="special-price-info">
                        <span class="original-price">13,000원</span>
                        <span class="special-price">9,600원</span>
                        <span class="price-label">적립</span>
                    </div>
                </div>
            </div>

            <!-- 특가 도서 카드 2 -->
            <div class="special-book-card">
                <div class="special-badges">
                    <div class="discount-percent">% 70%</div>
                    <div class="days-left">1일 남음</div>
                </div>
                <div class="special-book-image">
                    <img src="https://via.placeholder.com/160x220/3182ce/ffffff?text=사피엔스" alt="사피엔스">
                </div>
                <div class="special-book-info">
                    <div class="book-category">인문</div>
                    <h3 class="special-book-title">사피엔스</h3>
                    <p class="special-book-author">유발 하라리</p>
                    <div class="special-price-info">
                        <span class="original-price">22,000원</span>
                        <span class="special-price">15,400원</span>
                        <span class="price-label">적립</span>
                    </div>
                </div>
            </div>

            <!-- 특가 도서 카드 3 -->
            <div class="special-book-card">
                <div class="special-badges">
                    <div class="discount-percent">% 80%</div>
                    <div class="days-left">3일 남음</div>
                </div>
                <div class="special-book-image">
                    <img src="https://via.placeholder.com/160x220/8b4513/ffffff?text=나+홀로+유럽여행" alt="나 홀로 유럽여행">
                </div>
                <div class="special-book-info">
                    <div class="book-category">여행</div>
                    <h3 class="special-book-title">나 홀로 유럽여행</h3>
                    <p class="special-book-author">김영미</p>
                    <div class="special-price-info">
                        <span class="original-price">16,500원</span>
                        <span class="special-price">13,200원</span>
                        <span class="price-label">적립</span>
                    </div>
                </div>
            </div>

            <!-- 특가 도서 카드 4 -->
            <div class="special-book-card">
                <div class="special-badges">
                    <div class="discount-percent">% 70%</div>
                    <div class="days-left">5일 남음</div>
                </div>
                <div class="special-book-image">
                    <img src="https://via.placeholder.com/160x220/2d3748/ffffff?text=마술창업의+기술" alt="마술창업의 기술">
                </div>
                <div class="special-book-info">
                    <div class="book-category">자기계발</div>
                    <h3 class="special-book-title">마술창업의 기술</h3>
                    <p class="special-book-author">존 카맥진</p>
                    <div class="special-price-info">
                        <span class="original-price">18,000원</span>
                        <span class="special-price">12,600원</span>
                        <span class="price-label">적립</span>
                    </div>
                </div>
            </div>

            <!-- 특가 도서 카드 5 -->
            <div class="special-book-card">
                <div class="special-badges">
                    <div class="discount-percent">% 75%</div>
                    <div class="days-left">4일 남음</div>
                </div>
                <div class="special-book-image">
                    <img src="https://via.placeholder.com/160x220/805ad5/ffffff?text=디자인의+디자인" alt="디자인의 디자인">
                </div>
                <div class="special-book-info">
                    <div class="book-category">예술</div>
                    <h3 class="special-book-title">디자인의 디자인</h3>
                    <p class="special-book-author">하라 겐야</p>
                    <div class="special-price-info">
                        <span class="original-price">25,000원</span>
                        <span class="special-price">18,750원</span>
                        <span class="price-label">적립</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="special-notice">
            <div class="notice-text">
                <span class="notice-icon">⚠️</span>
                특가 할인은 매주 일요일 자정에 종료됩니다
            </div>
            <button class="view-all-special-btn">전체 특가 보기</button>
        </div>
    </section>

    <!-- 오디오북 섹션 -->
    <section class="audiobook-section">
        <div class="audiobook-header">
            <div class="audiobook-title-area">
                <div class="audiobook-icon">🎧</div>
                <div class="audiobook-title-text">
                    <h2 class="audiobook-main-title">글벗 오디오북</h2>
                    <p class="audiobook-subtitle">언제 어디서나 듣는 독서의 새로운 경험</p>
                </div>
            </div>
            <div class="audiobook-actions">
                <button class="free-trial-btn">▶ 무료 체험 가능</button>
                <a href="/audiobooks" class="audiobook-more-link">전체보기 ></a>
            </div>
        </div>

        <div class="audiobook-grid">
            <!-- 오디오북 카드 1 -->
            <div class="audiobook-card">
                <div class="audiobook-badge new">NEW</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/667eea/ffffff?text=미스터리+카페의+비밀" alt="미스터리 카페의 비밀">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">7시간 32분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.8</span>
                        <span class="audiobook-category">스릴러</span>
                    </div>
                    <h3 class="audiobook-title">미스터리 카페의 비밀</h3>
                    <p class="audiobook-author">저자: 김수진</p>
                    <p class="audiobook-narrator">낭독: 박지혜</p>
                </div>
            </div>

            <!-- 오디오북 카드 2 -->
            <div class="audiobook-card">
                <div class="audiobook-badge popular">인기</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/2d3748/ffffff?text=심야+추리소설" alt="심야 추리소설">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">9시간 15분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.6</span>
                        <span class="audiobook-category">미스터리</span>
                    </div>
                    <h3 class="audiobook-title">심야 추리소설</h3>
                    <p class="audiobook-author">저자: 이정민</p>
                    <p class="audiobook-narrator">낭독: 김동원</p>
                </div>
            </div>

            <!-- 오디오북 카드 3 -->
            <div class="audiobook-card">
                <div class="audiobook-badge new">NEW</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/4ecdc4/ffffff?text=라자+센빌리티" alt="라자 센빌리티">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">6시간 48분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.9</span>
                        <span class="audiobook-category">로맨스</span>
                    </div>
                    <h3 class="audiobook-title">라자 센빌리티</h3>
                    <p class="audiobook-author">저자: 박소영</p>
                    <p class="audiobook-narrator">낭독: 최향울</p>
                </div>
            </div>

            <!-- 오디오북 카드 4 -->
            <div class="audiobook-card">
                <div class="audiobook-badge popular">인기</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/f9ca24/ffffff?text=창업가의+회고록" alt="창업가의 회고록">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">8시간 22분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.7</span>
                        <span class="audiobook-category">자서전</span>
                    </div>
                    <h3 class="audiobook-title">창업가의 회고록</h3>
                    <p class="audiobook-author">저자: 정태호</p>
                    <p class="audiobook-narrator">낭독: 김영우</p>
                </div>
            </div>

            <!-- 오디오북 카드 5 -->
            <div class="audiobook-card">
                <div class="audiobook-badge popular">인기</div>
                <div class="audiobook-cover">
                    <img src="https://via.placeholder.com/160x220/805ad5/ffffff?text=우주+탐험기" alt="우주 탐험기">
                    <div class="audio-icon">🎧</div>
                    <div class="play-time">10시간 5분</div>
                </div>
                <div class="audiobook-info">
                    <div class="audiobook-rating">
                        <span class="rating-stars">⭐ 4.5</span>
                        <span class="audiobook-category">SF</span>
                    </div>
                    <h3 class="audiobook-title">우주 탐험기</h3>
                    <p class="audiobook-author">저자: 김과학</p>
                    <p class="audiobook-narrator">낭독: 이우주</p>
                </div>
            </div>
        </div>

        <!-- 오디오북 프로모션 -->
        <div class="audiobook-promotion">
            <div class="promo-content-box">
                <div class="promo-icon-large">🎧</div>
                <div class="promo-text">
                    <h3 class="promo-main-title">첫 달 무료체험</h3>
                    <p class="promo-description">매월 1권 무료 + 30% 할인혜택</p>
                </div>
                <button class="start-trial-btn">무료체험 시작하기</button>
            </div>
            <a href="/audiobooks-all" class="more-audiobooks-link">더 많은 오디오북 보기</a>
        </div>
    </section>

    <!-- 수상 섹션 -->
    <section class="awards-section">
        <div class="awards-header">
            <h2>수상 및 인증</h2>
            <p>고객님께 더 나은 서비스를 제공하기 위한 저희의 노력이 다양한 기관으로부터 인정받고 있습니다.</p>
        </div>
        <div class="awards-cards">
            <div class="award-card yellow">
                <div class="icon">🏆</div>
                <div class="year">2024년</div>
                <div class="title">대한민국 우수서점상</div>
                <div class="subtitle">문화체육관광부 장관상</div>
                <div class="desc">고객 서비스 및 도서 큐레이션 부문</div>
            </div>
            <div class="award-card lightblue">
                <div class="icon">🥇</div>
                <div class="year">2023년</div>
                <div class="title">온라인 서점 대상</div>
                <div class="subtitle">한국서점협회</div>
                <div class="desc">디지털 혁신 및 사용자 경험</div>
            </div>
            <div class="award-card orange">
                <div class="icon">🎖️</div>
                <div class="year">2023년</div>
                <div class="title">베스트 북커머스</div>
                <div class="subtitle">온라인쇼핑몰협회</div>
                <div class="desc">고객 만족도 최우수</div>
            </div>
            <div class="award-card blue">
                <div class="icon">⭐</div>
                <div class="year">2022년</div>
                <div class="title">독서문화진흥 공로상</div>
                <div class="subtitle">국립중앙도서관</div>
                <div class="desc">지역 독서문화 확산 기여</div>
            </div>
        </div>
        <div class="awards-footer">
            <p>신뢰할 수 있는 온라인 서점</p>
            <p>2020년부터 지금까지 누적 고객 만족도 98.5%를 달성하며, 독자 여러분께 사랑받는 서점으로 성장해왔습니다. 앞으로도 더 나은 독서 환경을 만들어 나가겠습니다.</p>
            <div class="features">
                <span class="feature red">● 안전한 결제 시스템</span>
                <span class="feature green">● 신속한 배송 서비스</span>
                <span class="feature navy">● 전문 큐레이션</span>
                <span class="feature yellow">● 24시간 고객지원</span>
            </div>
        </div>
    </section>
</div>
</section>
</div>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
            /*** === 편집장의 선택 (탭 자동 슬라이드) === ***/
            let currentTabIndex = 0;
            let autoSlideInterval = null;
            let isPlaying = false;
            const autoSlideDelay = 4000;


        const tabItems = document.querySelectorAll('.tab-item');
        const playButton = document.querySelector('.play-button');

        const tabContents = [
        'editor-choice-content',
        'event-content',
        'weekly-content',
        'new-books-content',
        'trending-content',
        'goods-content',
        'hotdeal-content'
        ];

        const tabTexts = [
        '편집장의 선택',
        '추천 이벤트',
        '이 주의 책',
        '신간 소개',
        '화제의 책',
        '이벤트 굿즈',
        '지금 핫딜중'
        ];

        function showTabContent(tabIndex) {
        tabItems.forEach(t => t.classList.remove('active'));
        if (tabItems[tabIndex]) {
        tabItems[tabIndex].classList.add('active');
    }

        tabContents.forEach(contentId => {
        const content = document.getElementById(contentId);
        if (content) {
        content.style.display = 'none';
        content.classList.remove('active');
    }
    });

        const activeContent = document.getElementById(tabContents[tabIndex]);
        if (activeContent) {
        activeContent.style.display = 'block';
        activeContent.classList.add('active');
    }

        const sectionTitle = document.getElementById('section-title');
        if (sectionTitle) {
        sectionTitle.textContent = tabTexts[tabIndex];
    }

        currentTabIndex = tabIndex;
    }

        function nextTabSlide() {
        currentTabIndex = (currentTabIndex + 1) % tabContents.length;
        showTabContent(currentTabIndex);
    }

        function prevTabSlide() {
        currentTabIndex = (currentTabIndex - 1 + tabContents.length) % tabContents.length;
        showTabContent(currentTabIndex);
    }

        function startAutoSlide() {
        if (!isPlaying) {
        isPlaying = true;
        autoSlideInterval = setInterval(nextTabSlide, autoSlideDelay);
        playButton.classList.remove('playing');
        playButton.classList.add('paused');
    }
    }

        function stopAutoSlide() {
        if (isPlaying) {
        isPlaying = false;
        clearInterval(autoSlideInterval);
        autoSlideInterval = null;
        playButton.classList.remove('paused');
        playButton.classList.add('playing');
    }
    }

        if (playButton) {
        playButton.addEventListener('click', function() {
        if (isPlaying) {
        stopAutoSlide();
    } else {
        startAutoSlide();
    }
    });
    }

        if (tabItems.length > 0) {
        tabItems.forEach((tab, index) => {
        tab.addEventListener('click', function() {
        if (isPlaying) {
        stopAutoSlide();
    }
        showTabContent(index);
    });
    });
    }

        // === 탭용 전역 함수 등록 ===
        window.nextTab = function() {
        if (isPlaying) stopAutoSlide();
        nextTabSlide();
    };

        window.prevTab = function() {
        if (isPlaying) stopAutoSlide();
        prevTabSlide();
    };

        showTabContent(0);
        setTimeout(() => {
        startAutoSlide();
    }, 1000);


        /*** === 큰 광고 배너 슬라이드 === ***/
        let currentBannerSlide = 0;
        const totalBannerSlides = 3;
        let bannerInterval = null;
        let userInteracting = false;

        function updateBannerSlider() {
        const sliderTrack = document.getElementById('sliderTrack');
        if (sliderTrack) {
        const translateX = -currentBannerSlide * 33.333;
        sliderTrack.style.transform = `translateX(${translateX}%)`;
    }
    }

        function nextBannerSlide() {
        currentBannerSlide = (currentBannerSlide + 1) % totalBannerSlides;
        updateBannerSlider();
    }

        function prevBannerSlide() {
        currentBannerSlide = (currentBannerSlide - 1 + totalBannerSlides) % totalBannerSlides;
        updateBannerSlider();
    }

        function startBannerAutoSlide() {
        bannerInterval = setInterval(() => {
        if (!userInteracting) {
        nextBannerSlide();
    }
    }, 4000);
    }

        function stopBannerAutoSlide() {
        if (bannerInterval) {
        clearInterval(bannerInterval);
        bannerInterval = null;
    }
    }

        function resetBannerAutoSlide() {
        stopBannerAutoSlide();
        userInteracting = false;
        setTimeout(() => {
        startBannerAutoSlide();
    }, 3000);
    }

        // 전역 등록 (HTML 버튼에서 호출 가능)
        window.nextBanner = function() {
        userInteracting = true;
        stopBannerAutoSlide();
        nextBannerSlide();
        resetBannerAutoSlide();
    }

        window.prevBanner = function() {
        userInteracting = true;
        stopBannerAutoSlide();
        prevBannerSlide();
        resetBannerAutoSlide();
    }

        // 배너 자동 시작
        setTimeout(() => {
        startBannerAutoSlide();
    }, 2000);

        console.log('BookStore 웹사이트가 성공적으로 로드되었습니다!');
    });


    </script>
</body>
</html>