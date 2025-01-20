
# **API Flutter com Imagem e Texto**

Este é um aplicativo Flutter que interage com uma API local para criar, exibir e gerenciar posts. Cada post contém um texto e uma imagem. O aplicativo permite que os usuários visualizem uma lista de posts, adicionem novos posts com imagens e texto, e façam upload dessas informações para a API.

---

## **Funcionalidades Principais**

1. **Exibir Posts**
   - A lista de posts é buscada de um servidor local em `http://localhost:8080/posts`.
   - Cada post contém:
     - Um **texto** descritivo.
     - Uma **imagem**, exibida como miniatura (se disponível).

2. **Adicionar Novo Post**
   - Permite ao usuário:
     - Digitar um texto para o post.
     - Escolher uma imagem da galeria do dispositivo.
   - Faz upload do texto e da imagem (codificada em Base64) para o servidor.

3. **Selecionar Imagem**
   - Utiliza a biblioteca `image_picker` para abrir a galeria de imagens do dispositivo.
   - Converte a imagem selecionada para o formato Base64 para ser enviada ao servidor.

---

## **Arquitetura do Aplicativo**

### **1. Tela Inicial - `PostListScreen`**
   - Busca os posts disponíveis na API ao inicializar.
   - Exibe os posts em um `ListView.builder`.
   - Botão flutuante (`FloatingActionButton`) para adicionar novos posts.

### **2. Tela de Adição de Posts - `AddPostScreen`**
   - Formulário para adicionar texto e imagem a um novo post.
   - **Funções principais**:
     - `pickImage`: Abre a galeria do dispositivo e seleciona uma imagem.
     - `submitPost`: Envia o post (texto + imagem em Base64) para o servidor via requisição HTTP `POST`.

---

## **Configuração do Servidor**

1. **API Local**:
   - O aplicativo se conecta ao servidor na URL `http://localhost:8080/posts`.
   - Certifique-se de que o servidor está em execução antes de iniciar o aplicativo.
   - **Rotas utilizadas**:
     - `GET /posts`: Retorna a lista de posts.
     - `POST /posts`: Adiciona um novo post.

2. **Modelo de Post**:
   - Cada post no servidor deve ser armazenado no seguinte formato:
     ```json
     {
       "texto": "Descrição do post",
       "imagem": "Base64 da imagem"
     }
     ```

---

## **Como Executar o Aplicativo**

1. **Pré-requisitos**:
   - Flutter SDK instalado.
   - Dependências do projeto: `http`, `image_picker`, `flutter/foundation`.

2. **Instalação**:
   - Clone este repositório.
   - Execute o comando: `flutter pub get`.

3. **Executar**:
   - Inicie o servidor local na porta 8080.
   - Execute o comando: `flutter run`.

---

## **Tecnologias Utilizadas**

- **Flutter**: Framework para desenvolvimento de aplicativos.
- **Dart**: Linguagem de programação.
- **HTTP**: Comunicação com a API.
- **Image Picker**: Seleção de imagens do dispositivo.

---

## **Capturas de Tela**

### 1. Lista de Posts
- Exibe posts com texto e miniatura da imagem.

### 2. Adicionar Post
- Permite selecionar imagem e adicionar descrição.

---

## **Melhorias Futuras**

- Suporte a edição e exclusão de posts.
- Integração com um servidor remoto.
- Tratamento de erros mais robusto.

**Desenvolvido em Flutter!**
