# Escribo EBOOK

## Descrição

O **Escribo EBOOK** é um aplicativo de leitura de ebooks. O aplicativo oferece uma experiencia interativa e facil de usar para os usuários, permitindo que leiam e baixem ebooks de forma eficiente.

## Funcionalidades

1. **Baixar Livros**
   - Os usuários podem baixar livros ao clicar em suas capas. Uma notificação de download é exibida ao iniciar o processo, e, uma vez concluído, o usuário pode abrir o eBook para leitura.
2. **Adicionar Favoritos**
  -  possível marcar livros como favoritos com um toque no ícone vermelho contornado localizado no canto superior direito de cada capa de livro. Ao salvar um livro como favorito, o ícone se torna um vermelho sólido, e o livro é armazenado na lista de favoritos.
3. **Exibição de livros**
  - Utilizando o plugin [Vocsy Epub Viewer](https://pub.dev/packages/vocsy_epub_viewer) é possivel fazer a leitura do livro. As anotações, onde parou e outras configurações personalizadas, tudo ficará salvo.

## Outras Informações
  - Os eBooks baixados são armazenados no diretório Android/data/com.example.escribo_flutter_anderson/files.
  - Um sistema de fila gerencia os downloads, garantindo que os arquivos sejam baixados na ordem desejada. Livros já baixados são destacados, enquanto aqueles em processo de download apresentam uma leve opacidade.
  - O progresso do download é exibido na parte inferior do aplicativo e nas notificações da barra de status, desde que a permissão seja concedida.

## Bug conhecidos
  - Há um bug quando clica no icone de pesquisar do plugin Vocsy Epub Viewer, que acaba resultando no fechamento inesperado do visualizador.

APK INSTALAÇÃO: [escribo-ebook-1.0_release.apk](https://github.com/andeersonluiz/escriboFlutterAnderson/releases/download/v1.0/escribo-ebook-1.0_release.apk)




