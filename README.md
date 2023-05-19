
# Índices


* [Leilão do galpão](#leilão-do-galpão)

* [O que esse app faz](#o-que-esse-app-faz)

* [Pré-requisitos](#pré-requisitos)

* [Como rodar a aplicação](#como-rodar-a-aplicação)

* [Testes](#testes)

* [Banco de dados](#banco-de-dados)

* [CRUD](#crud)

* [Informações úteis sobre os modelos](#informações-úteis-sobre-os-modelos)

* [Orientações sobre uso](#orientações-sobre-uso)

* [Pendências](#pendências)

* [Status do projeto](#status-do-projeto)


## Leilão do galpão

Um sistema de leilão com foco em itens e produtos cuja comercialização nas redes de varejo e outros estabelecimentos se torna inviável, ou por possuir pequenas avárias, ou por qualquer outra condição que não os tornem mais atrativos para o consumo.



## O que esse app faz

- Conecta detentores dos produtos com potenciais consumidores
- Um administrador é capaz de cadastrar produtos e lotes de produtos
## Pré-requisitos

- ruby 3.1+
- rails 7.0+

## Como rodar a aplicação

Primeiro clone o projeto:

`git clone https://github.com/ClaufSS/stock-auction.git`

Entre no diretório do projeto:

`cd auction-app`

Instale as dependências do projeto:

`bundle install`

Talvez você queira sair testando a aplicação sem ter que modelos do zero, para isso existe um arquivo com alguns modelos pré-definidos, para carregar execute o seguinte comando:

`rails db:seed`

Em seguida, execute o servidor local:

`rails server`


Se nenhuma falha ocorrer durante esse processo, será possível acessar a aplicação atravéz do navegador no endereço http://localhost:3000/


## Testes
Para executar os testes para essa aplicação, execute o comando
`rspec`

## Banco de dados

A modelagem do banco de dados possui seguinte estrutura:

![db](https://github.com/ClaufSS/stock-auction/assets/82234131/622d8261-9271-4d83-aa47-3b19c6e937e8)

## CRUD

### Usuários

:heavy_check_mark: Podem se cadastrar acessando o formulário 'Regsitrar-se' na tela de login

### Item de leilão

:heavy_check_mark: Podem ser cadastrados por adiministrador a partir de formulário na tela 'Novo item'
:heavy_check_mark: Podem ser acessados a partir de lista na página do lote de itens

### Lote de itens

:heavy_check_mark: Podem ser cadastrados por adiministrador a partir de formulário na tela 'Novo lote'
:heavy_check_mark: Podem ser acessados a partir de diversas páginas a depender do status

## Informações úteis sobre os modelos

### Usuários
Se você optou por carregar os modelos pré-definidos é útil saber que no meio disso há usuários, tanto regulares quanto administradores, e que para fins de praticidade todos compartilham da mesma senha (12345678).

*Os usuários cadastrados são:*


>Usuários regulares
>||
>|-----|
>|`marcos@gmail.com`|
>|`silvaneide@gmail.com`|
>|`silvanei@gmail.com`|
>|`carlos@gmail.com`|
>||

> Administradores
>||
>|-|
>|`jose@leilaodogalpao.com.br`|
>|`victor@leilaodogalpao.com.br`|

### Imagens
Há dentro do diretório `/public` uma pasta chamada 'photo_items' populado por imagens. Ela é útil para criar os modelos pré-definidos.

## Orientações sobre uso

- Para se cadastrar como administrador deve usar email com domínio "@leilaodogalpao.com.br"

- CPF do cadastro deve ser matematicamente válido

- CPF e email não podem ser usados em mais de um cadastro

- Apenas administradores podem criar item e lotes

- Administrador deve encerrar um lote antes para que o usuário possa ver na sua tela de conquistas

## Pendências

- Refatorar modelo de lote (Lot --> AuctionLot)
- Estilização da interface com bootstrap

## Status do projeto

> Status do Projeto: Em desenvolvimento :warning:
