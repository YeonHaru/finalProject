package com.error404.geulbut.jpa.users.service;

import com.error404.geulbut.jpa.users.dto.UsersOAuthUpsertDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final SocialAuthService socialAuthService;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest){
        OAuth2User raw = super.loadUser(userRequest);
        Map<String, Object> attributes = raw.getAttributes();
        String registrationId = userRequest.getClientRegistration().getRegistrationId(); // google/naver/kakao

//        1) DTO 만들고 업서트
        UsersOAuthUpsertDto dto = socialAuthService.buildUpsertDto(registrationId, attributes);
        socialAuthService.upsertUser(dto);

//        2) 사람이 볼 이름 추출해서 어트리뷰트에 심기
        String displayName = extractDisplayName(registrationId, attributes);
        Map<String,Object> attrs = new LinkedHashMap<>(attributes);
        attrs.put("displayName", (displayName != null && !displayName.isBlank()) ? displayName : "사용자");
        attrs.putIfAbsent("userId", dto.toUserIdKey());

//        3) 기본 nameAttributeKey는 그대로(= sub/id), 권한은 ROLE 접두사 권장
        String nameAttrKey = userRequest.getClientRegistration()
                .getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();
        return new DefaultOAuth2User(
//   "ROLE" IN ('USER','ADMIN','MANAGER') db 제약조건안에 보면 3개중 USER 사용해야함
                List.of(new SimpleGrantedAuthority("USER")),
                attrs,
                nameAttrKey
        );
    }

    private String extractDisplayName(String rid, Map<String, Object> attributes){
        switch (rid){
            case "google":
                return (String) attributes.get("name");

            case "naver": {
                Object resp = attributes.get("response");
                if (resp instanceof Map) {
                    Object name = ((Map<?, ?>) resp).get("name");
                    return name != null ? String.valueOf(name) : null;
                }
                return null;
            }
            case "kakao": {
                Object acc = attributes.get("kakao_account");
                if (acc instanceof Map) {
                    Object prof = ((Map<?, ?>) acc).get("profile");
                    if (prof instanceof Map) {
                        Object nick = ((Map<?, ?>) prof).get("nickname");
                        return nick != null ? String.valueOf(nick) : null;
                    }
                }
                return null;
            }
            default:
                return null;
        }
    }
    private String str(Object o){
        return (o == null) ? null : o.toString();
    }
}
