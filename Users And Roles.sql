-- Testdome Users And Roles 문제
-- https://www.testdome.com/questions/sql/users-and-roles/108278

CREATE TABLE usersRoles (
  userId INTEGER NOT NULL,
  roleId INTEGER NOT NULL,
  FOREIGN KEY (userId) REFERENCES users(id),
  FOREIGN KEY (roleId) REFERENCES roles(id),
  PRIMARY KEY (userId, roleId)
);