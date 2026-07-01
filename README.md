# Emmanuel DevKit

CLI para preparar e gerenciar ambiente de desenvolvimento em Ubuntu/WSL.

O objetivo do projeto é automatizar a configuração de ferramentas usadas no dia a dia de desenvolvimento, principalmente para ambientes Java legado, Java moderno, Node, Angular, Tomcat, WildFly/JBoss e utilitários de terminal.

## Objetivo

O Emmanuel DevKit foi criado para facilitar a montagem de um ambiente de desenvolvimento completo com poucos comandos.

A ideia é que uma pessoa possa clonar o projeto, executar o instalador e depois usar o comando `edev` para instalar ferramentas, verificar o ambiente e controlar servidores locais.

## Comando principal

```bash
edev
```

## Instalação

Clone o projeto:

```bash
git clone https://github.com/SEU_USUARIO/emmanuel-devkit.git
cd emmanuel-devkit
```

Execute o instalador:

```bash
./install.sh
```

Recarregue o terminal:

```bash
source ~/.zshrc
```

ou:

```bash
source ~/.bashrc
```

Depois teste:

```bash
edev help
```

## Estrutura do projeto

```text
emmanuel-devkit/
├── bin/
│   └── edev
├── lib/
│   ├── core.sh
│   ├── prompts.sh
│   ├── paths.sh
│   ├── ubuntu.sh
│   ├── java.sh
│   ├── node.sh
│   └── servers.sh
├── installers/
│   ├── setup-base.sh
│   ├── setup-node.sh
│   ├── setup-java-legacy.sh
│   ├── setup-java-modern.sh
│   └── setup-servers.sh
├── install.sh
├── uninstall.sh
├── README.md
├── CHANGELOG.md
└── .gitignore
```

## Recursos

* Instalação de pacotes base no Ubuntu/WSL
* Configuração de workspace de desenvolvimento
* Suporte a Node com NVM
* Suporte a Java com mise
* Suporte manual a JDK 6
* Instalação de Maven
* Instalação de Apache Ant
* Instalação de Tomcat
* Instalação de WildFly/JBoss
* Comandos utilitários para iniciar, parar e visualizar logs de servidores
* Comando `doctor` para verificar ferramentas instaladas

## Comandos principais

Mostrar ajuda:

```bash
edev help
```

Verificar ambiente:

```bash
edev doctor
```

Instalar ambiente base:

```bash
edev setup base
```

Instalar ambiente Node:

```bash
edev setup node
```

Instalar ambiente Java legado:

```bash
edev setup java-legacy
```

Instalar ambiente Java moderno:

```bash
edev setup java-modern
```

Instalar servidores locais:

```bash
edev setup servers
```

Instalar tudo:

```bash
edev setup all
```

## Java

Mostrar Java ativo:

```bash
edev java info
```

Instalar uma versão Java com mise:

```bash
edev java install temurin-17
```

Selecionar uma versão Java global:

```bash
edev java use temurin-17
```

Exemplos de versões:

```bash
edev java install temurin-8
edev java install temurin-11
edev java install temurin-17
edev java install temurin-21
```

## Java legado

O projeto possui suporte para ambiente Java legado.

Versões recomendadas para instalar via `mise`:

```text
Java 8
Java 11
```

Para Java 6, o DevKit não realiza download automático por questões de segurança e licença. O JDK 6 deve ser obtido de fonte oficial ou fornecido pelo time/projeto legado.

Caminho esperado para JDK 6 manual:

```text
~/apps/jdks/jdk6
```

## Servidores

### Tomcat

Iniciar Tomcat:

```bash
edev server tomcat start
```

Parar Tomcat:

```bash
edev server tomcat stop
```

Reiniciar Tomcat:

```bash
edev server tomcat restart
```

Ver log do Tomcat:

```bash
edev server tomcat log
```

### WildFly/JBoss

Iniciar WildFly/JBoss:

```bash
edev server jboss start
```

Parar WildFly/JBoss:

```bash
edev server jboss stop
```

Reiniciar WildFly/JBoss:

```bash
edev server jboss restart
```

Ver log do WildFly/JBoss:

```bash
edev server jboss log
```

## Caminhos padrão

Workspace:

```text
~/dev
```

Projetos:

```text
~/dev/projects
```

Aplicações instaladas:

```text
~/apps
```

Tomcat:

```text
~/apps/tomcats/tomcat9
```

WildFly/JBoss:

```text
~/apps/jbosses/wildfly26
```

JDKs manuais:

```text
~/apps/jdks
```

## Configuração local

Para customizar caminhos sem alterar os arquivos versionados, crie um arquivo local de configuração.

Exemplo futuro:

```bash
export EDEV_WORKSPACE="$HOME/dev"
export EDEV_PROJECTS_DIR="$HOME/dev/projects"
export EDEV_APPS_DIR="$HOME/apps"
export EDEV_TOMCAT_HOME="$HOME/apps/tomcats/tomcat9"
export EDEV_WILDFLY_HOME="$HOME/apps/jbosses/wildfly26"
export EDEV_JAVA6_HOME="$HOME/apps/jdks/jdk6"
```

Arquivos locais de configuração não devem ser versionados.

## Filosofia do projeto

O projeto deve ser:

* Simples de instalar
* Fácil de entender
* Modular
* Seguro para uso público
* Compatível com Ubuntu e WSL
* Idempotente, evitando reinstalar o que já existe
* Evolutivo, permitindo adicionar novos ambientes no futuro

## Roadmap

Possíveis melhorias futuras:

* Setup Docker
* Setup PostgreSQL
* Setup Oracle Client
* Setup Angular
* Setup React Native
* Setup Spring Boot
* Setup Java legado com templates de projeto
* Comando para criar projetos base
* Suporte a proxy corporativo
* Comando de atualização do próprio DevKit
* Testes automatizados com ShellCheck
* Instalação não interativa com flags

## Desenvolvimento

Verificar arquivos alterados:

```bash
git status
```

Adicionar arquivos:

```bash
git add .
```

Criar commit:

```bash
git commit -m "feat: adicionar nova funcionalidade"
```

Enviar para o GitHub:

```bash
git push
```

## Licença

Este projeto pode ser usado como base para estudos e automação de ambiente de desenvolvimento.
