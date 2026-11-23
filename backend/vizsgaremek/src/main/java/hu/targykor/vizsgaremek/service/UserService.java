package hu.targykor.vizsgaremek.service;

import hu.targykor.vizsgaremek.dto.request.CreateUserRequest;
import hu.targykor.vizsgaremek.dto.request.UpdateUserRequest;
import hu.targykor.vizsgaremek.dto.response.UserResponse;
import hu.targykor.vizsgaremek.exception.EmailAlreadyExistsException;
import hu.targykor.vizsgaremek.exception.ResourceNotFoundException;
import hu.targykor.vizsgaremek.exception.UsernameAlreadyExistsException;
import hu.targykor.vizsgaremek.model.User;
import hu.targykor.vizsgaremek.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public UserResponse createUser(CreateUserRequest request) {
        if(userRepository.existsByUsername(request.getUsername())) {
            throw new UsernameAlreadyExistsException("Ez a felhasználónév már foglalt: " + request.getUsername());
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new EmailAlreadyExistsException("Ez az email már foglalt: " + request.getEmail());
        }
        User saved=userRepository.createUser(
                request.getUsername(),
                request.getFirstName(),
                request.getLastName(),
                request.getEmail(),
                request.getPhoneNumber(),
                passwordEncoder.encode(request.getPassword()));

        return toResponseDto(saved);
    }

    public List<UserResponse> getAllUser(){
        return userRepository.getAllUser().stream()
                .map(this::toResponseDto)
                .toList();
    }

    private UserResponse toResponseDto(User user){
        return UserResponse.builder()
                .id(user.getId())
                .username(user.getUsername())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .avatarUrl(user.getAvatarUrl())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .role(user.getRole())
                .emailVerifiedAt(user.getEmailVerifiedAt())
                .lastLogin(user.getLastLogin())
                .createdAt(user.getCreatedAt())
                .updatedAt(user.getUpdatedAt())
                .build();
    }

    public UserResponse getUserById(Integer id){
        User user=userRepository.getUserById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Nincs ilyen felhasználó: " + id));
        return toResponseDto(user);
    }

    @Transactional
    public UserResponse updateUser(Integer id, UpdateUserRequest request){
        User user=userRepository.getUserById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Nincs ilyen felhasználó: " + id));

        if (!user.getUsername().equals(request.getUsername())&& userRepository.existsByUsername(request.getUsername())){
            throw new UsernameAlreadyExistsException("Ez az felhasználónéb már foglalt: " + request.getUsername());
        }

        if (!user.getEmail().equals(request.getEmail())&& userRepository.existsByEmail(request.getEmail())){
            throw new EmailAlreadyExistsException("Ez az email már foglalt: " + request.getEmail());
        }

        User saved=userRepository.updateUser(
                id,
                request.getUsername(),
                request.getFirstName(),
                request.getLastName(),
                request.getAvatarUrl(),
                request.getEmail(),
                request.getPhoneNumber())
                .orElseThrow(() -> new ResourceNotFoundException("Nincs ilyen felhasználó: " + id));
        return toResponseDto(saved);

    }

    @Transactional
    public void softDeleteUser(Integer id){
        User user=userRepository.getUserById(id)
                .orElseThrow(()->new ResourceNotFoundException("Nincs ilyen felhasználó: "+id));
        userRepository.softDeleteUser(id);
    }
}
