# App de Contatos

Projeto mobile em Flutter com CRUD completo de contatos, persistencia local com SQLite e persistencia remota usando uma API propria em Node.js publicada no Render com PostgreSQL.

## Participantes 

Nome:Vinicius de Araújo Silva
Nome:Thiago Archete Cunha
Nome:Paulo Ricardo Alvino de Azevedo



## Funcionalidades

- Tela inicial ou dashboard para escolher o tipo de persistencia.
- Listagem de contatos.
- Cadastro de novos contatos.
- Atualizacao de contatos existentes.
- Exclusao de contatos.
- Mensagens de erro e sucesso.
- Atualizacao visual da lista apos cadastro, edicao ou exclusao.
- Persistencia local com SQLite.
- Persistencia remota via API REST.
- API propria preparada para deploy no Render.
- Banco PostgreSQL no Render.

## Estrutura do projeto

```text
lib/
  components/
    editor.dart
  db/
    app_database.dart
  models/
    contato.dart
  repository/
    contato_repository.dart
    tipo_persistencia.dart
  screens/
    dashboard.dart
    contato/
      formulario.dart
      lista.dart
  services/
    contato_api_service.dart

api/
  src/
    controllers/
    repositories/
    routes/
    app.js
    db.js
    server.js
  package.json
  README.md
```

## Tecnologias utilizadas

### Aplicativo

- Flutter
- Dart
- SQLite com `sqflite`
- HTTP com pacote `http`
- Repository Pattern
- Service Layer

### API

- Node.js
- Express
- PostgreSQL
- `pg`
- `cors`
- `dotenv`

## Como rodar o aplicativo Flutter

Instale as dependencias:

```bash
flutter pub get
```

Rode o app usando persistencia local:

```bash
flutter run
```

Para usar a API publicada no Render, informe a URL da API:

```bash
flutter run --dart-define=API_BASE_URL=https://sua-api.onrender.com
```

No app, escolha no dashboard:

- `SQLite local` para salvar no aparelho.
- `API Render` para salvar remotamente no PostgreSQL.

## Como rodar a API localmente

Entre na pasta da API:

```bash
cd api
```

Instale as dependencias:

```bash
npm install
```

Crie um arquivo `.env` baseado em `api/.env.example`:

```env
DATABASE_URL=postgresql://usuario:senha@localhost:5432/contatos
PORT=3000
```

Inicie a API:

```bash
npm run dev
```

A API ficara disponivel em:

```text
http://localhost:3000
```

## Rotas da API

### Verificar status

```http
GET /health
```

### Listar contatos

```http
GET /contatos
```

### Buscar contato por id

```http
GET /contatos/:id
```

### Cadastrar contato

```http
POST /contatos
```

Corpo da requisicao:

```json
{
  "nome": "Joao Silva",
  "telefone": "(11) 99999-9999",
  "email": "joao@email.com"
}
```

### Atualizar contato

```http
PUT /contatos/:id
```

Corpo da requisicao:

```json
{
  "nome": "Joao Silva",
  "telefone": "(11) 98888-8888",
  "email": "joao@email.com"
}
```

### Deletar contato

```http
DELETE /contatos/:id
```

## Como publicar no Render

### 1. Criar o banco PostgreSQL

No painel do Render:

1. Clique em `+ New`.
2. Escolha `Postgres`.
3. Defina um nome para o banco, por exemplo `contatos-db`.
4. Escolha a mesma regiao que sera usada pela API.
5. Clique em `Create Database`.

Quando o banco ficar disponivel, copie a `Internal Database URL`.

### 2. Publicar a API

No painel do Render:

1. Clique em `+ New`.
2. Escolha `Web Service`.
3. Conecte o repositorio do projeto.
4. Configure:

```text
Root Directory: api
Build Command: npm install
Start Command: npm start
```

5. Em `Environment`, adicione:

```text
DATABASE_URL=<Internal Database URL do PostgreSQL>
```

6. Faca o deploy.

A tabela `contatos` e criada automaticamente quando a API inicia.

### 3. Conectar o Flutter na API

Depois do deploy, copie a URL publica da API no Render e rode:

```bash
flutter run --dart-define=API_BASE_URL=https://sua-api.onrender.com
```

## Modelo de dados

```text
Contato
- id
- nome
- telefone
- email
```

## Observacoes

- O SQLite e usado apenas no modo de persistencia local.
- O PostgreSQL e usado apenas no modo de persistencia remota.
- A camada `services` faz a comunicacao HTTP com a API.
- A camada `repository` decide se os dados serao salvos localmente ou remotamente.
- Para ambiente Render, use a `Internal Database URL` na variavel `DATABASE_URL`.
