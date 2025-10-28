# Documento de Design

## Visão Geral

API REST para autenticação multi-role com três tipos de usuários (admin, user, member) usando JWT tokens. Cada tipo de usuário possui endpoints específicos organizados em namespaces separados.

## Arquitetura

### Estrutura de Rotas
```
/api/admin/login    (POST)   - Login de administradores
/api/admin/logout   (DELETE) - Logout de administradores
/api/users/login    (POST)   - Login de usuários regulares
/api/users/logout   (DELETE) - Logout de usuários regulares
/api/members/login  (POST)   - Login de membros
/api/members/logout (DELETE) - Logout de membros
```

### Hierarquia de Controladores
```
ApplicationController
└── Api::BaseController
    ├── Api::Admin::SessionsController
    ├── Api::Users::SessionsController
    └── Api::Members::SessionsController
```

## Componentes e Interfaces

### 1. Api::BaseController
- Controlador base para todos os endpoints da API
- Configura resposta JSON por padrão
- Implementa tratamento de erros padronizado
- Inclui helpers para autenticação JWT

### 2. Controladores de Sessão
Cada controlador (`Api::Admin::SessionsController`, `Api::Users::SessionsController`, `Api::Members::SessionsController`) implementa:

#### Método `create` (Login)
- Recebe credenciais via JSON
- Valida credenciais contra modelo apropriado
- Gera JWT token em caso de sucesso
- Retorna resposta JSON padronizada

#### Método `destroy` (Logout)
- Recebe token JWT via header Authorization
- Invalida token (blacklist ou expiração)
- Retorna confirmação de logout

### 3. Serviço JWT
- `JwtService.encode(payload)` - Gera token JWT
- `JwtService.decode(token)` - Decodifica e valida token
- `JwtService.blacklist(token)` - Invalida token

## Modelos de Dados

### Estrutura de Usuários
Assumindo modelos separados ou STI (Single Table Inheritance):

```ruby
# Opção 1: Modelos separados
class Admin < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
end

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
end

class Member < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
end

# Opção 2: STI com modelo base
class BaseUser < ApplicationRecord
  self.table_name = 'users'
  has_secure_password
  validates :email, presence: true, uniqueness: true
end

class Admin < BaseUser; end
class User < BaseUser; end
class Member < BaseUser; end
```

### Payload JWT
```json
{
  "user_id": 123,
  "user_type": "admin|user|member",
  "email": "user@example.com",
  "exp": 1640995200,
  "iat": 1640908800
}
```

## Formato de Respostas

### Login Bem-sucedido (200)
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 123,
      "email": "admin@example.com",
      "type": "admin"
    }
  },
  "message": "Login realizado com sucesso"
}
```

### Erro de Autenticação (401)
```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Email ou senha inválidos"
  }
}
```

### Logout Bem-sucedido (200)
```json
{
  "success": true,
  "message": "Logout realizado com sucesso"
}
```

### Erro de Validação (422)
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Dados inválidos",
    "details": {
      "email": ["não pode ficar em branco"],
      "password": ["é muito curta (mínimo: 6 caracteres)"]
    }
  }
}
```

## Tratamento de Erros

### Middleware de Tratamento de Erros
- Captura exceções não tratadas
- Retorna respostas JSON padronizadas
- Log de erros para monitoramento

### Tipos de Erro
1. **Credenciais Inválidas** (401) - Email/senha incorretos
2. **Token Inválido** (401) - JWT expirado ou malformado
3. **Dados Inválidos** (422) - Falha na validação
4. **Erro Interno** (500) - Exceções não previstas

## Estratégia de Testes

### Testes de Controlador
- Teste de login com credenciais válidas
- Teste de login com credenciais inválidas
- Teste de logout com token válido
- Teste de logout com token inválido
- Teste de validação de dados de entrada

### Testes de Integração
- Fluxo completo de login/logout para cada tipo de usuário
- Teste de acesso a endpoints protegidos com diferentes tipos de token
- Teste de invalidação de token após logout

### Testes de Serviço JWT
- Geração de token válido
- Decodificação de token válido
- Rejeição de token expirado
- Rejeição de token malformado

## Considerações de Segurança

1. **Senhas**: Usar bcrypt via `has_secure_password`
2. **JWT Secret**: Armazenar em variável de ambiente
3. **HTTPS**: Forçar HTTPS em produção
4. **Rate Limiting**: Implementar limite de tentativas de login
5. **Token Expiration**: Definir tempo de expiração apropriado
6. **Blacklist**: Manter lista de tokens invalidados