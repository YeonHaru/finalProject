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

        UsersOAuthUpsertDto dto = socialAuthService.buildUpsertDto(registrationId, attributes);
        socialAuthService.upsertUser(dto);

        String nameAttrKey = userRequest.getClientRegistration()
                .getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();
        return new DefaultOAuth2User(
                List.of(new SimpleGrantedAuthority("ROLE_USER")),
                attributes,
                nameAttrKey
        );
    }
}
