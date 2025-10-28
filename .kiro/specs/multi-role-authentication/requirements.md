# Documento de Requisitos

## Introdução

API de autenticação multi-role que permite login separado para três tipos de usuários: administradores, usuários regulares e membros, cada um com endpoints e controladores específicos que retornam respostas JSON.

## Glossário

- **Sistema_Autenticacao**: O sistema Rails responsável por gerenciar autenticação e autorização
- **Admin**: Usuário com privilégios administrativos completos
- **User**: Usuário regular com acesso padrão ao sistema
- **Member**: Usuário com acesso limitado/específico ao sistema
- **Sessao**: Estado de autenticação mantido pelo sistema após login bem-sucedido
- **Endpoint_Login**: Endpoint API específico para cada tipo de usuário realizar autenticação
- **Token_JWT**: Token de autenticação retornado após login bem-sucedido
- **Resposta_JSON**: Formato de resposta padronizado da API

## Requisitos

### Requisito 1

**User Story:** Como um administrador, eu quero ter um endpoint de login específico para admins, para que eu possa autenticar via API e acessar funcionalidades administrativas.

#### Critérios de Aceitação

1. O Sistema_Autenticacao DEVE fornecer endpoint `POST /api/admin/login` para autenticação de administradores
2. QUANDO um admin envia credenciais válidas para `/api/admin/login`, O Sistema_Autenticacao DEVE retornar Token_JWT com privilégios administrativos
3. QUANDO um admin envia credenciais inválidas, O Sistema_Autenticacao DEVE retornar Resposta_JSON com status 401 e mensagem de erro
4. A Resposta_JSON de sucesso DEVE incluir token, tipo de usuário e dados básicos do admin
5. O Sistema_Autenticacao DEVE validar formato JSON da requisição

### Requisito 2

**User Story:** Como um usuário regular, eu quero ter um endpoint de login específico para usuários, para que eu possa autenticar via API e acessar funcionalidades padrão.

#### Critérios de Aceitação

1. O Sistema_Autenticacao DEVE fornecer endpoint `POST /api/users/login` para autenticação de usuários regulares
2. QUANDO um user envia credenciais válidas para `/api/users/login`, O Sistema_Autenticacao DEVE retornar Token_JWT com privilégios de usuário regular
3. QUANDO um user envia credenciais inválidas, O Sistema_Autenticacao DEVE retornar Resposta_JSON com status 401 e mensagem de erro
4. A Resposta_JSON de sucesso DEVE incluir token, tipo de usuário e dados básicos do usuário
5. O Sistema_Autenticacao DEVE validar formato JSON da requisição

### Requisito 3

**User Story:** Como um membro, eu quero ter um endpoint de login específico para membros, para que eu possa autenticar via API e acessar funcionalidades específicas.

#### Critérios de Aceitação

1. O Sistema_Autenticacao DEVE fornecer endpoint `POST /api/members/login` para autenticação de membros
2. QUANDO um member envia credenciais válidas para `/api/members/login`, O Sistema_Autenticacao DEVE retornar Token_JWT com privilégios de membro
3. QUANDO um member envia credenciais inválidas, O Sistema_Autenticacao DEVE retornar Resposta_JSON com status 401 e mensagem de erro
4. A Resposta_JSON de sucesso DEVE incluir token, tipo de usuário e dados básicos do membro
5. O Sistema_Autenticacao DEVE validar formato JSON da requisição

### Requisito 4

**User Story:** Como desenvolvedor do sistema, eu quero que cada tipo de usuário tenha controladores API separados, para que a lógica de autenticação seja organizada e mantível.

#### Critérios de Aceitação

1. O Sistema_Autenticacao DEVE implementar controlador `Api::Admin::SessionsController` para gerenciar autenticação de administradores
2. O Sistema_Autenticacao DEVE implementar controlador `Api::Users::SessionsController` para gerenciar autenticação de usuários regulares
3. O Sistema_Autenticacao DEVE implementar controlador `Api::Members::SessionsController` para gerenciar autenticação de membros
4. CADA controlador DEVE herdar de `Api::BaseController` com funcionalidades API
5. CADA controlador DEVE implementar métodos `create` e `destroy` para login/logout via API

### Requisito 5

**User Story:** Como usuário do sistema, eu quero poder fazer logout via API, para que minha sessão seja invalidada de forma segura.

#### Critérios de Aceitação

1. O Sistema_Autenticacao DEVE fornecer endpoint `DELETE /api/admin/logout` para logout de administradores
2. O Sistema_Autenticacao DEVE fornecer endpoint `DELETE /api/users/logout` para logout de usuários regulares
3. O Sistema_Autenticacao DEVE fornecer endpoint `DELETE /api/members/logout` para logout de membros
4. QUANDO qualquer usuário envia requisição para seu endpoint de logout, O Sistema_Autenticacao DEVE invalidar o Token_JWT
5. APÓS logout bem-sucedido, O Sistema_Autenticacao DEVE retornar Resposta_JSON com status 200 confirmando logout