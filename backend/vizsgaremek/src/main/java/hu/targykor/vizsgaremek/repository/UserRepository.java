package hu.targykor.vizsgaremek.repository;

import hu.targykor.vizsgaremek.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.StoredProcedureQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class UserRepository {
    private final EntityManager entityManager;

    public User createUser(String username, String firstName, String lastName, String email, String phoneNumber, String password) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("createUser", User.class);

        query.registerStoredProcedureParameter(1, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(2, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(3, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(4, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(5, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(6, String.class, ParameterMode.IN);

        query.setParameter(1, username);
        query.setParameter(2, firstName);
        query.setParameter(3, lastName);
        query.setParameter(4, email);
        query.setParameter(5, phoneNumber);
        query.setParameter(6, password);

        List<User> result = query.getResultList();
        return result.get(0);
    }

    public List<User> getAllUser() {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("getAllUser", User.class);
        return query.getResultList();
    }

    public Optional<User> getUserById(Integer id) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("getUserById", User.class);
        query.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN);
        query.setParameter(1, id);

        List<User> result = query.getResultList();
        return result.stream().findFirst();
    }

    public Optional<User> getUserByEmail(String email) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("getUserByEmail", User.class);
        query.registerStoredProcedureParameter(1, String.class, ParameterMode.IN);
        query.setParameter(1, email);

        List<User> result = query.getResultList();
        return result.stream().findFirst();
    }

    public boolean existsByEmail(String email) {
        return getUserByEmail(email).isPresent();
    }

    public Optional<User> getUserByUsername(String username){
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("getUserByUsername", User.class);
        query.registerStoredProcedureParameter(1, String.class, ParameterMode.IN);
        query.setParameter(1, username);

        List<User> result = query.getResultList();
        return result.stream().findFirst();
    }

    public boolean existsByUsername(String username){return getUserByUsername(username).isPresent();}

    public Optional<User> updateUser(Integer id, String username, String firstName, String lastName,String avatarUrl, String email, String phoneNumber) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("updateUser", User.class);

        query.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(2, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(3, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(4, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(5, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(6, String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter(7, String.class, ParameterMode.IN);

        query.setParameter(1, id);
        query.setParameter(2, username);
        query.setParameter(3, firstName);
        query.setParameter(4, lastName);
        query.setParameter(5, avatarUrl);
        query.setParameter(6, email);
        query.setParameter(7, phoneNumber);

        List<User> result = query.getResultList();
        return result.stream().findFirst();
    }

    public void softDeleteUser(Integer id) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("softDeleteUser", User.class);

        query.registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN);
        query.setParameter(1, id);

        query.execute();
    }
}
