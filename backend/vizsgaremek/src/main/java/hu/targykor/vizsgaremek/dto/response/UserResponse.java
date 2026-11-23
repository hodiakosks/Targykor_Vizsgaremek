package hu.targykor.vizsgaremek.dto.response;

import hu.targykor.vizsgaremek.model.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@Builder
public class UserResponse {
    private Integer id;
    private String username;
    private String firstName;
    private String lastName;
    private String avatarUrl;
    private String email;
    private String phoneNumber;
    private Role role;
    private LocalDateTime emailVerifiedAt;
    private LocalDateTime lastLogin;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
