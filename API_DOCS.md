# Documentação da API - Autenticação

## Endpoints de Registro (Signup)

### 1. Signup Admin

**Endpoint:** `POST /api/v1/auth/admin/signup`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/admin/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "newadmin@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

**Response Success (201):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 4,
    "email": "newadmin@example.com",
    "role": "admin"
  }
}
```

**Response Error (422):**
```json
{
  "errors": [
    "Email has already been taken",
    "Password confirmation doesn't match Password"
  ]
}
```

---

### 2. Signup User

**Endpoint:** `POST /api/v1/auth/user/signup`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/user/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "newuser@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

**Response Success (201):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 5,
    "email": "newuser@example.com",
    "role": "user"
  }
}
```

**Response Error (422):**
```json
{
  "errors": [
    "Email has already been taken"
  ]
}
```

---

### 3. Signup Member

**Endpoint:** `POST /api/v1/auth/member/signup`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/member/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "newmember@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

**Response Success (201):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 6,
    "email": "newmember@example.com",
    "role": "member"
  }
}
```

**Response Error (422):**
```json
{
  "errors": [
    "Email can't be blank",
    "Password is too short (minimum is 6 characters)"
  ]
}
```

---

## Endpoints de Login

### 1. Login Admin

**Endpoint:** `POST /api/v1/auth/admin/login`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/admin/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "password123"
  }'
```

**Response Success (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "admin@example.com",
    "role": "admin"
  }
}
```

**Response Error (401):**
```json
{
  "error": "Invalid credentials"
}
```

---

### 2. Login User

**Endpoint:** `POST /api/v1/auth/user/login`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

**Response Success (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 2,
    "email": "user@example.com",
    "role": "user"
  }
}
```

**Response Error (401):**
```json
{
  "error": "Invalid credentials"
}
```

---

### 3. Login Member

**Endpoint:** `POST /api/v1/auth/member/login`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/member/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "member@example.com",
    "password": "password123"
  }'
```

**Response Success (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 3,
    "email": "member@example.com",
    "role": "member"
  }
}
```

**Response Error (401):**
```json
{
  "error": "Invalid credentials"
}
```

---

## Usando o Token JWT

Após o login, use o token retornado no header Authorization das próximas requisições:

```bash
curl -X GET http://localhost:3000/api/v1/protected_resource \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..."
```

---

## Setup do Projeto

1. Instalar dependências:
```bash
bundle install
```

2. Criar e migrar o banco de dados:
```bash
rails db:create
rails db:migrate
```

3. Popular o banco com usuários de teste:
```bash
rails db:seed
```

4. Iniciar o servidor:
```bash
rails server
```

---

## Credenciais de Teste

- **Admin:** admin@example.com / password123
- **User:** user@example.com / password123
- **Member:** member@example.com / password123


---

## Endpoints de Cursos (Somente Members)

### 1. Listar Cursos com Progresso

**Endpoint:** `GET /api/v1/courses`

**Descrição:** Lista todos os cursos ativos com o progresso do membro autenticado

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/courses \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..." \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "courses": [
    {
      "id": 1,
      "title": "Ruby on Rails Fundamentals",
      "description": "Learn the basics of Ruby on Rails framework",
      "total_lessons": 20,
      "progress": {
        "completed_lessons": 10,
        "percentage": 50.0,
        "last_accessed_at": "2024-10-25T10:30:00.000Z"
      }
    },
    {
      "id": 2,
      "title": "Advanced JavaScript",
      "description": "Master advanced JavaScript concepts and patterns",
      "total_lessons": 15,
      "progress": {
        "completed_lessons": 5,
        "percentage": 33.33,
        "last_accessed_at": "2024-10-26T14:20:00.000Z"
      }
    },
    {
      "id": 3,
      "title": "React for Beginners",
      "description": "Build modern web applications with React",
      "total_lessons": 25,
      "progress": {
        "completed_lessons": 0,
        "percentage": 0.0,
        "last_accessed_at": null
      }
    }
  ]
}
```

**Response Error (403):**
```json
{
  "error": "Access denied. Members only."
}
```

**Response Error (401):**
```json
{
  "error": "Unauthorized"
}
```

---

### 2. Atualizar Progresso do Curso

**Endpoint:** `PATCH /api/v1/courses/:id/update_progress`

**Descrição:** Atualiza o progresso do membro em um curso específico

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/courses/1/update_progress \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "completed_lessons": 15
  }'
```

**Response Success (200):**
```json
{
  "message": "Progress updated successfully",
  "progress": {
    "course_id": 1,
    "completed_lessons": 15,
    "percentage": 75.0,
    "last_accessed_at": "2024-10-27T16:45:00.000Z"
  }
}
```

**Response Error (404):**
```json
{
  "error": "Course not found"
}
```

**Response Error (403):**
```json
{
  "error": "Access denied. Members only."
}
```

**Response Error (422):**
```json
{
  "errors": [
    "Completed lessons must be greater than or equal to 0"
  ]
}
```

---

## Exemplo de Fluxo Completo

### 1. Fazer login como membro
```bash
curl -X POST http://localhost:3000/api/v1/auth/member/login \
  -H "Content-Type: application/json" \
  -d '{"email":"member@example.com","password":"password123"}'
```

### 2. Listar cursos (usando o token recebido)
```bash
curl -X GET http://localhost:3000/api/v1/courses \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -H "Content-Type: application/json"
```

### 3. Atualizar progresso
```bash
curl -X PATCH http://localhost:3000/api/v1/courses/1/update_progress \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{"completed_lessons": 15}'
```


---

## Endpoints de Administração de Cursos (Somente Admins)

### 1. Criar Curso

**Endpoint:** `POST /api/v1/admin/courses`

**Descrição:** Cria um novo curso (somente admins)

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/admin/courses \
  -H "Authorization: Bearer ADMIN_TOKEN_AQUI" \
  -F "title=Node.js Avançado" \
  -F "description=Aprenda Node.js do zero ao avançado" \
  -F "total_lessons=30" \
  -F "active=true" \
  -F "photo=@/path/to/image.jpg"
```

**Response Success (201):**
```json
{
  "message": "Course created successfully",
  "course": {
    "id": 4,
    "title": "Node.js Avançado",
    "description": "Aprenda Node.js do zero ao avançado",
    "photo_url": "/rails/active_storage/blobs/...",
    "total_lessons": 30,
    "active": true
  }
}
```

**Response Error (403):**
```json
{
  "error": "Access denied. Admins only."
}
```

---

### 2. Atualizar Curso

**Endpoint:** `PATCH /api/v1/admin/courses/:id`

**Descrição:** Atualiza um curso existente (somente admins)

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/admin/courses/1 \
  -H "Authorization: Bearer ADMIN_TOKEN_AQUI" \
  -F "title=Ruby on Rails Fundamentals - Updated" \
  -F "total_lessons=25" \
  -F "photo=@/path/to/new-image.jpg"
```

**Response Success (200):**
```json
{
  "message": "Course updated successfully",
  "course": {
    "id": 1,
    "title": "Ruby on Rails Fundamentals - Updated",
    "description": "Learn the basics of Ruby on Rails framework",
    "photo_url": "/rails/active_storage/blobs/...",
    "total_lessons": 25,
    "active": true
  }
}
```

**Response Error (404):**
```json
{
  "error": "Course not found"
}
```

---

### 3. Deletar Curso

**Endpoint:** `DELETE /api/v1/admin/courses/:id`

**Descrição:** Deleta um curso (somente admins)

**Request:**
```bash
curl -X DELETE http://localhost:3000/api/v1/admin/courses/1 \
  -H "Authorization: Bearer ADMIN_TOKEN_AQUI" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "message": "Course deleted successfully"
}
```

**Response Error (404):**
```json
{
  "error": "Course not found"
}
```

---

## Exemplo de Response com Foto

Quando um curso tem foto anexada, a listagem retorna:

```json
{
  "courses": [
    {
      "id": 1,
      "title": "Ruby on Rails Fundamentals",
      "description": "Learn the basics of Ruby on Rails framework",
      "photo_url": "/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--abc123/course-image.jpg",
      "total_lessons": 20,
      "progress": {
        "completed_lessons": 10,
        "percentage": 50.0,
        "last_accessed_at": "2024-10-25T10:30:00.000Z"
      }
    }
  ]
}
```

Se o curso não tem foto, `photo_url` será `null`.


---

## Endpoints de Aulas (Lessons)

### 1. Listar Aulas de um Curso (Members)

**Endpoint:** `GET /api/v1/courses/:course_id/lessons`

**Descrição:** Lista todas as aulas de um curso com progresso do membro

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/courses/1/lessons \
  -H "Authorization: Bearer MEMBER_TOKEN_AQUI" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "course_id": 1,
  "course_title": "Ruby on Rails Fundamentals",
  "lessons": [
    {
      "id": 1,
      "title": "Introdução ao Rails",
      "description": "Visão geral do framework",
      "video_url": "https://example.com/video1.mp4",
      "order_number": 1,
      "duration_minutes": 15,
      "progress": {
        "completed": true,
        "watched_seconds": 900,
        "completed_at": "2024-10-24T10:30:00.000Z"
      }
    },
    {
      "id": 2,
      "title": "MVC Pattern",
      "description": "Entendendo Model-View-Controller",
      "video_url": "https://example.com/video2.mp4",
      "order_number": 2,
      "duration_minutes": 20,
      "progress": {
        "completed": false,
        "watched_seconds": 450,
        "completed_at": null
      }
    }
  ]
}
```

---

### 2. Atualizar Progresso da Aula (Members)

**Endpoint:** `PATCH /api/v1/lessons/:id/update_progress`

**Descrição:** Atualiza o progresso do membro em uma aula específica

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/lessons/1/update_progress \
  -H "Authorization: Bearer MEMBER_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "watched_seconds": 900,
    "completed": true
  }'
```

**Response Success (200):**
```json
{
  "message": "Lesson progress updated successfully",
  "progress": {
    "lesson_id": 1,
    "completed": true,
    "watched_seconds": 900,
    "completed_at": "2024-10-27T18:30:00.000Z"
  }
}
```

**Response Error (404):**
```json
{
  "error": "Lesson not found"
}
```

---

## Endpoints de Administração de Aulas (Admins)

### 1. Criar Aula

**Endpoint:** `POST /api/v1/admin/courses/:course_id/lessons`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/admin/courses/1/lessons \
  -H "Authorization: Bearer ADMIN_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Nova Aula",
    "description": "Descrição da aula",
    "video_url": "https://example.com/video.mp4",
    "order_number": 6,
    "duration_minutes": 30
  }'
```

**Response Success (201):**
```json
{
  "message": "Lesson created successfully",
  "lesson": {
    "id": 6,
    "course_id": 1,
    "title": "Nova Aula",
    "description": "Descrição da aula",
    "video_url": "https://example.com/video.mp4",
    "order_number": 6,
    "duration_minutes": 30
  }
}
```

---

### 2. Atualizar Aula

**Endpoint:** `PATCH /api/v1/admin/lessons/:id`

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/admin/lessons/1 \
  -H "Authorization: Bearer ADMIN_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Introdução ao Rails - Atualizado",
    "duration_minutes": 18
  }'
```

**Response Success (200):**
```json
{
  "message": "Lesson updated successfully",
  "lesson": {
    "id": 1,
    "course_id": 1,
    "title": "Introdução ao Rails - Atualizado",
    "description": "Visão geral do framework",
    "video_url": "https://example.com/video1.mp4",
    "order_number": 1,
    "duration_minutes": 18
  }
}
```

---

### 3. Deletar Aula

**Endpoint:** `DELETE /api/v1/admin/lessons/:id`

**Request:**
```bash
curl -X DELETE http://localhost:3000/api/v1/admin/lessons/1 \
  -H "Authorization: Bearer ADMIN_TOKEN_AQUI" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "message": "Lesson deleted successfully"
}
```

---

## Fluxo Completo de Uso

### 1. Login como membro
```bash
curl -X POST http://localhost:3000/api/v1/auth/member/login \
  -H "Content-Type: application/json" \
  -d '{"email":"member@example.com","password":"password123"}'
```

### 2. Listar cursos
```bash
curl -X GET http://localhost:3000/api/v1/courses \
  -H "Authorization: Bearer TOKEN"
```

### 3. Listar aulas do curso
```bash
curl -X GET http://localhost:3000/api/v1/courses/1/lessons \
  -H "Authorization: Bearer TOKEN"
```

### 4. Assistir aula e atualizar progresso
```bash
curl -X PATCH http://localhost:3000/api/v1/lessons/1/update_progress \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"watched_seconds": 450, "completed": false}'
```

### 5. Marcar aula como completa
```bash
curl -X PATCH http://localhost:3000/api/v1/lessons/1/update_progress \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"watched_seconds": 900, "completed": true}'
```


---

## Endpoints de Administração de Usuários (Admins)

### 1. Listar Usuários

**Endpoint:** `GET /api/v1/admin/users`

**Query Params:** `?role=member&status=active`

**Request:**
```bash
curl -X GET "http://localhost:3000/api/v1/admin/users?role=member" \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "users": [
    {
      "id": 1,
      "name": "João Silva",
      "email": "member@example.com",
      "role": "member",
      "status": "active",
      "subscription_status": "subscriber",
      "blocked_at": null,
      "created_at": "2024-10-20T10:00:00.000Z"
    }
  ]
}
```

---

### 2. Ver Detalhes do Usuário

**Endpoint:** `GET /api/v1/admin/users/:id`

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/admin/users/1 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "user": {
    "id": 1,
    "name": "João Silva",
    "email": "member@example.com",
    "role": "member",
    "status": "active",
    "subscription_status": "subscriber",
    "blocked_at": null,
    "created_at": "2024-10-20T10:00:00.000Z",
    "stats": {
      "total_courses": 3,
      "completed_courses": 1,
      "total_sales": 299.90,
      "sales_count": 2
    }
  }
}
```

---

### 3. Criar Usuário

**Endpoint:** `POST /api/v1/admin/users`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/admin/users \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Maria Santos",
    "email": "maria@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "role": "member"
  }'
```

**Response Success (201):**
```json
{
  "message": "User created successfully",
  "user": {
    "id": 10,
    "name": "Maria Santos",
    "email": "maria@example.com",
    "role": "member",
    "status": "active",
    "subscription_status": "free",
    "blocked_at": null,
    "created_at": "2024-10-27T18:00:00.000Z"
  }
}
```

---

### 4. Atualizar Usuário

**Endpoint:** `PATCH /api/v1/admin/users/:id`

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/admin/users/1 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva Updated",
    "subscription_status": "subscriber"
  }'
```

**Response Success (200):**
```json
{
  "message": "User updated successfully",
  "user": {
    "id": 1,
    "name": "João Silva Updated",
    "email": "member@example.com",
    "role": "member",
    "status": "active",
    "subscription_status": "subscriber",
    "blocked_at": null,
    "created_at": "2024-10-20T10:00:00.000Z"
  }
}
```

---

### 5. Deletar Usuário

**Endpoint:** `DELETE /api/v1/admin/users/:id`

**Request:**
```bash
curl -X DELETE http://localhost:3000/api/v1/admin/users/1 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "message": "User deleted successfully"
}
```

---

### 6. Bloquear Usuário

**Endpoint:** `PATCH /api/v1/admin/users/:id/block`

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/admin/users/1/block \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "message": "User blocked successfully",
  "user": {
    "id": 1,
    "name": "João Silva",
    "email": "member@example.com",
    "role": "member",
    "status": "blocked",
    "subscription_status": "subscriber",
    "blocked_at": "2024-10-27T18:30:00.000Z",
    "created_at": "2024-10-20T10:00:00.000Z"
  }
}
```

---

### 7. Desbloquear Usuário

**Endpoint:** `PATCH /api/v1/admin/users/:id/unblock`

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/admin/users/1/unblock \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "message": "User unblocked successfully",
  "user": {
    "id": 1,
    "status": "active",
    "blocked_at": null
  }
}
```

---

### 8. Ver Vendas do Usuário

**Endpoint:** `GET /api/v1/admin/users/:id/sales`

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/admin/users/1/sales \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "user_id": 1,
  "user_email": "member@example.com",
  "total_sales": 299.90,
  "sales": [
    {
      "id": 1,
      "amount": 149.90,
      "payment_method": "credit_card",
      "status": "completed",
      "notes": "Assinatura mensal",
      "created_at": "2024-10-15T10:00:00.000Z"
    },
    {
      "id": 2,
      "amount": 150.00,
      "payment_method": "pix",
      "status": "completed",
      "notes": "Renovação",
      "created_at": "2024-10-25T14:30:00.000Z"
    }
  ]
}
```

---

## Endpoints de Vendas (Admins)

### 1. Listar Todas as Vendas

**Endpoint:** `GET /api/v1/admin/sales`

**Query Params:** `?status=completed&user_id=1`

**Request:**
```bash
curl -X GET "http://localhost:3000/api/v1/admin/sales?status=completed" \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "sales": [
    {
      "id": 1,
      "user": {
        "id": 1,
        "name": "João Silva",
        "email": "member@example.com",
        "subscription_status": "subscriber"
      },
      "amount": 149.90,
      "payment_method": "credit_card",
      "status": "completed",
      "notes": "Assinatura mensal",
      "created_at": "2024-10-15T10:00:00.000Z",
      "updated_at": "2024-10-15T10:05:00.000Z"
    }
  ],
  "summary": {
    "total_completed": 1499.00,
    "total_pending": 299.90,
    "count_completed": 10,
    "count_pending": 2
  }
}
```

---

### 2. Criar Venda

**Endpoint:** `POST /api/v1/admin/sales`

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/admin/sales \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "amount": 149.90,
    "payment_method": "credit_card",
    "status": "pending",
    "notes": "Assinatura mensal"
  }'
```

**Response Success (201):**
```json
{
  "message": "Sale created successfully",
  "sale": {
    "id": 5,
    "user": {
      "id": 1,
      "name": "João Silva",
      "email": "member@example.com",
      "subscription_status": "free"
    },
    "amount": 149.90,
    "payment_method": "credit_card",
    "status": "pending",
    "notes": "Assinatura mensal",
    "created_at": "2024-10-27T19:00:00.000Z",
    "updated_at": "2024-10-27T19:00:00.000Z"
  }
}
```

---

### 3. Atualizar Venda (Mudar Status para Completed)

**Endpoint:** `PATCH /api/v1/admin/sales/:id`

**Descrição:** Quando o status muda para "completed", o usuário automaticamente vira "subscriber"

**Request:**
```bash
curl -X PATCH http://localhost:3000/api/v1/admin/sales/5 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "completed"
  }'
```

**Response Success (200):**
```json
{
  "message": "Sale updated successfully",
  "sale": {
    "id": 5,
    "user": {
      "id": 1,
      "name": "João Silva",
      "email": "member@example.com",
      "subscription_status": "subscriber"
    },
    "amount": 149.90,
    "payment_method": "credit_card",
    "status": "completed",
    "notes": "Assinatura mensal",
    "created_at": "2024-10-27T19:00:00.000Z",
    "updated_at": "2024-10-27T19:05:00.000Z"
  }
}
```

---

### 4. Deletar Venda

**Endpoint:** `DELETE /api/v1/admin/sales/:id`

**Request:**
```bash
curl -X DELETE http://localhost:3000/api/v1/admin/sales/5 \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json"
```

**Response Success (200):**
```json
{
  "message": "Sale deleted successfully"
}
```
