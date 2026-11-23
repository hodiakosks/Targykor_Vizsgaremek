package hu.targykor.vizsgaremek.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateUserRequest {
    @NotBlank(message = "A felhasználónév megadása kötelező")
    @Size(max = 100, message = "A felhasználónév legfeljebb 100 karakter lehet")
    private String username;

    @NotBlank(message = "A keresztnév megadása kötelező")
    @Size(max=50, message = "A keresztnév legfeljebb 50 karakter lehet")
    private String firstName;

    @NotBlank(message = "A vezetéknév megadása kötelező")
    @Size(max=50, message = "A vezetéknév legfeljebb 50 karakter lehet")
    private String lastName;

    private String avatarUrl;

    @NotBlank(message = "A email megadása kötelező")
    @Email(message = "Nem érvényes email formátum")
    private String email;

    @Size(max=50, message = "A telefonszám legfeljebb 50 karater lehet")
    private String phoneNumber;



}
