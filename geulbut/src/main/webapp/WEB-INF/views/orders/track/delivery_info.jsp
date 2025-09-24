<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>배송조회</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<c:url value='/css/00_common.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/orders/deliveryInfo.css'/>">
    
</head>
<body>


<main class="page page--track" aria-labelledby="pageTitle">
    <h1 id="pageTitle" class="sr-only">배송조회</h1>


    <c:set var="o" value="${delivery.ordersDto}"/>
    <!-- enum toString()이 'READY' / 'IN_TRANSIT' / 'DELIVERED'로 비교 가능 -->
    <c:set var="vStatus" value="${delivery.viewDeliveryStatus}"/>

    <!-- DEBUG -->
    <p>DEBUG: vStatus = ${vStatus}, o.status = ${o.status}</p>

    <!-- 탭 -->
    <div class="tabs" role="tablist" aria-label="배송 상태">
        <button class="tab ${vStatus == 'READY' ? 'is-active' : ''}"
                role="tab" aria-selected="${vStatus == 'READY'}"
                aria-controls="panel-ready" id="tab-ready">배송준비</button>

        <button class="tab ${vStatus == 'IN_TRANSIT' ? 'is-active' : ''}"
                role="tab" aria-selected="${vStatus == 'IN_TRANSIT'}"
                aria-controls="panel-intransit" id="tab-intransit">배송중</button>

        <button class="tab ${vStatus == 'DELIVERED' ? 'is-active' : ''}"
                role="tab" aria-selected="${vStatus == 'DELIVERED'}"
                aria-controls="panel-delivered" id="tab-delivered">배송완료</button>
    </div>

    <!-- 패널: 배송준비 -->
    <section class="panel ${vStatus == 'READY' ? 'is-active' : ''}"
             role="tabpanel" id="panel-ready" aria-labelledby="tab-ready"
    ${vStatus == 'READY' ? '' : 'hidden'}>
        <article class="card">
            <header class="card__header">
                <h2 class="card__title">배송준비</h2>
                <span class="status status--ready">Ready</span>
            </header>

            <div class="grid grid--2">
                <div class="kv">
                    <span class="k">택배사</span>
                    <span class="v">${empty o.courierName ? '—' : o.courierName}</span>
                </div>
                <div class="kv">
                    <span class="k">송장번호</span>
                    <span class="v">${empty o.invoiceNo ? '—' : o.invoiceNo}</span>
                </div>
                <div class="kv">
                    <span class="k">예상도착</span>
                    <span class="v">
                        <c:choose>

                            <c:when test="${vStatus == 'DELIVERED' && not empty o.deliveredAtFormatted}">
                                ${o.deliveredAtFormatted}
                            </c:when>
                            <c:when test="${vStatus == 'IN_TRANSIT'}">
                                출고 후 1~2일 내 도착 예상
                            </c:when>
                            <c:when test="${vStatus == 'READY'}">
                                준비중 (결제 완료 기준)
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <!-- 상세 토글(선택 정보) -->
            <button class="detail-toggle" aria-expanded="false" aria-controls="detail-ready">상세보기</button>
            <div id="detail-ready" class="detail" hidden>
                <ul class="detail-list">
                    <li>결제수단: ${empty o.paymentMethod ? '—' : o.paymentMethod}</li>
                    <li>수취인: ${empty o.recipient ? '—' : o.recipient}</li>
                    <li>배송지: ${empty o.address ? '—' : o.address}</li>

                    <!-- 주문상품 목록 -->
                    <li>주문상품 목록</li>
                    <c:choose>
                        <c:when test="${not empty o.items}">
                            <ul class="order-items">
                                <c:forEach var="it" items="${o.items}">
                                    <li class="order-item">
                                        <div class="oi-wrap">
                                            <c:if test="${not empty it.imageUrl}">
                                                <img src="${it.imageUrl}" alt="${it.title}" class="oi-thumb"/>
                                            </c:if>
                                            <div class="oi-info">
                                                <div class="oi-title">${it.title}</div>
                                                <div class="oi-meta">
                                                    수량: ${it.quantity}
                                                    · 단가: <fmt:formatNumber value="${it.price}" type="number"/>원
                                                    · 소계: <fmt:formatNumber value="${it.price * it.quantity}" type="number"/>원
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p class="muted">주문상품 정보가 없습니다.</p>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </article>
    </section>

    <!-- 패널: 배송중 -->
    <section class="panel ${vStatus == 'IN_TRANSIT' ? 'is-active' : ''}"
             role="tabpanel" id="panel-intransit" aria-labelledby="tab-intransit"
    ${vStatus == 'IN_TRANSIT' ? '' : 'hidden'}>
        <article class="card">
            <header class="card__header">
                <h2 class="card__title">배송중</h2>
                <span class="status status--in">In Transit</span>
            </header>

            <div class="grid grid--2">
                <div class="kv">
                    <span class="k">송장번호</span>
                    <span class="v">${empty o.invoiceNo ? '—' : o.invoiceNo}</span>
                </div>
                <div class="kv">
                    <span class="k">택배사</span>
                    <span class="v">${empty o.courierName ? '—' : o.courierName}</span>
                </div>
                <div class="kv">
                    <span class="k">기사님</span>
                    <span class="v">${empty o.courierManName ? '—' : o.courierManName}</span>
                </div>
                <div class="kv">
                    <span class="k">연락처</span>
                    <span class="v">${empty o.courierManPhone ? '—' : o.courierManPhone}</span>
                </div>
            </div>

            <button class="detail-toggle" aria-expanded="false" aria-controls="detail-intransit">상세 이동경로</button>
            <div id="detail-intransit" class="detail" hidden>
                <p class="detail-list">이동 경로 정보가 준비되어 있지 않습니다.</p>
            </div>
        </article>
    </section>

    <!-- 패널: 배송완료 -->
    <section class="panel ${vStatus == 'DELIVERED' ? 'is-active' : ''}"
             role="tabpanel" id="panel-delivered" aria-labelledby="tab-delivered"
    ${vStatus == 'DELIVERED' ? '' : 'hidden'}>
        <article class="card">
            <header class="card__header">
                <h2 class="card__title">배송완료</h2>
                <span class="status status--done">Delivered</span>
            </header>

            <div class="grid grid--2">
                <div class="kv">
                    <span class="k">도착시간</span>
                    <span class="v">${empty o.deliveredAtFormatted ? '—' : o.deliveredAtFormatted}</span>
                </div>
                <div class="kv">
                    <span class="k">수령인</span>
                    <span class="v">${empty o.recipient ? '—' : o.recipient}</span>
                </div>
                <div class="kv">
                    <span class="k">배송지</span>
                    <span class="v">${empty o.address ? '—' : o.address}</span>
                </div>
            </div>

            <button class="detail-toggle" aria-expanded="false" aria-controls="detail-delivered">수령 상세</button>
            <div id="detail-delivered" class="detail" hidden>
                <ul class="detail-list">
                    <li>송장번호: ${empty o.invoiceNo ? '—' : o.invoiceNo}</li>
                    <li>택배사: ${empty o.courierName ? '—' : o.courierName}</li>
                </ul>
            </div>
        </article>
    </section>
</main>

<script>
    (function(){
        const tabs = document.querySelectorAll('.tab');
        const panels = document.querySelectorAll('.panel');

        function activateTab(targetId){
            tabs.forEach(t => {
                const active = (t.getAttribute('aria-controls') === targetId);
                t.classList.toggle('is-active', active);
                t.setAttribute('aria-selected', active);
            });
            panels.forEach(p => {
                const active = (p.id === targetId);
                p.classList.toggle('is-active', active);
                p.hidden = !active;
            });
        }

        tabs.forEach(tab => {
            tab.addEventListener('click', () => activateTab(tab.getAttribute('aria-controls')));
            tab.addEventListener('keydown', (e) => {
                if(e.key === 'Enter' || e.key === ' '){
                    e.preventDefault();
                    activateTab(tab.getAttribute('aria-controls'));
                }
            });
        });

        document.querySelectorAll('.detail-toggle').forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.getAttribute('aria-controls');
                const panel = document.getElementById(id);
                const expanded = btn.getAttribute('aria-expanded') === 'true';
                btn.setAttribute('aria-expanded', String(!expanded));
                panel.hidden = expanded;
            });
        });
    })();
</script>
</body>
</html>
