#!/usr/bin/env bash

set -e

# --- PERSONALIZAÇÃO ---
# Adicione, remova ou altere as linguagens e suas versões nesta lista.
# Use o formato 'linguagem@versão'. Você pode usar 'latest' para a última versão
# estável ou 'lts' para a versão de suporte a longo prazo (para runtimes como o Node.js).
languages=(
    "python@latest"
    "nodejs@lts"
    "golang@latest"
    "rust@latest"
    "java@lts"
    "kotlin@latest"
    "groovy@latest"
    "erlang@latest"
    "elixir@latest"
    "lua@5.1"
    "ruby@latest"
    "gradle@latest"
    "maven@latest"
)

# Verifica se o comando 'mise' está disponível no sistema.
if ! command -v mise &> /dev/null
then
    echo ">>> Instalando mise..."
    if curl https://mise.run | sh; then
        echo "✅ mise instalado com sucesso!"
        # Adiciona mise ao PATH para esta sessão
        export PATH="$HOME/.local/bin:$PATH"
    else
        echo "❌ Erro ao instalar mise. Verifique sua conexão com a internet."
        exit 1
    fi
fi

echo "Iniciando a instalação global das linguagens de programação com mise..."
echo "------------------------------------------------------------------"

# Itera sobre a lista de linguagens.
for lang in "${languages[@]}"
do
    echo ""
    echo ">>> Processando: ${lang}"

    # Instala a linguagem e versão especificadas.
    # O mise é inteligente e não reinstalará se já existir.
    echo "    Instalando ${lang}..."
    if mise install "${lang}"; then
        # Define a versão instalada como a padrão global.
        # Isso adicionará uma entrada no arquivo ~/.config/mise/config.toml
        echo "    Definindo ${lang} como global..."
        if mise use -g "${lang}"; then
            echo "    ✅ '${lang}' configurado com sucesso!"
        else
            echo "    ⚠️  Erro ao configurar ${lang} como global"
        fi
    else
        echo "    ❌ Erro ao instalar ${lang}"
    fi
done

echo ""
echo "------------------------------------------------------------------"
echo ">>> Instalando Spring Boot CLI..."

# Verifica se Java está instalado (requisito)
if ! command -v java &> /dev/null; then
    echo "    ⚠️  Java não encontrado. Spring Boot CLI requer Java 17+."
    echo "    Execute este script novamente após instalar Java."
else
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -lt 17 ] 2>/dev/null; then
        echo "    ⚠️  Java $JAVA_VERSION encontrado. Spring Boot CLI requer Java 17+."
        echo "    Execute este script novamente após atualizar Java."
    else
        echo "    ✅ Java $JAVA_VERSION encontrado (compatível)"

        # Instala Spring Boot CLI via SDKMAN se disponível, senão instala diretamente
        if command -v sdk &> /dev/null; then
            echo "    Usando SDKMAN para instalar Spring Boot CLI..."
            if sdk install springboot; then
                echo "    ✅ Spring Boot CLI instalado via SDKMAN!"
            else
                echo "    ⚠️  Erro ao instalar via SDKMAN, tentando instalação direta..."
            fi
        else
            echo "    Instalando Spring Boot CLI diretamente..."
            # Cria diretórios necessários
            mkdir -p ~/.local/bin ~/.local/share

            # URL oficial da documentação Spring Boot
            SPRING_VERSION="3.5.6"
            SPRING_URL="https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-cli/${SPRING_VERSION}/spring-boot-cli-${SPRING_VERSION}-bin.tar.gz"

            echo "    Baixando Spring Boot CLI ${SPRING_VERSION}..."
            if curl -L "$SPRING_URL" -o /tmp/spring-cli.tar.gz; then
                echo "    Extraindo arquivo..."
                if tar -xzf /tmp/spring-cli.tar.gz -C /tmp/; then
                    # Remove instalação anterior se existir
                    rm -rf ~/.local/share/spring-cli
                    mv "/tmp/spring-${SPRING_VERSION}" ~/.local/share/spring-cli

                    # Cria link simbólico para o binário
                    ln -sf ~/.local/share/spring-cli/bin/spring ~/.local/bin/spring
                    chmod +x ~/.local/bin/spring

                    # Limpa arquivo temporário
                    rm -f /tmp/spring-cli.tar.gz

                    echo "    ✅ Spring Boot CLI instalado em ~/.local/bin/spring"
                else
                    echo "    ❌ Erro ao extrair Spring Boot CLI"
                fi
            else
                echo "    ❌ Erro ao baixar Spring Boot CLI"
            fi
        fi
    fi
fi

echo ""
echo "------------------------------------------------------------------"
echo "✅ Instalação concluída!"
echo ""
echo "Ferramentas instaladas:"
echo "  • Linguagens de programação (mise)"
echo "  • Spring Boot CLI (spring)"
echo ""
echo "Para que as alterações tenham efeito, reinicie seu terminal ou abra uma nova aba."
echo ""
echo "Comandos disponíveis:"
echo "  • mise list                               - Verificar versões instaladas"
echo "  • spring --version                        - Verificar versão do Spring CLI"
echo "  • spring help                             - Ajuda do Spring Boot CLI"
echo "  • spring init --list                      - Listar dependências disponíveis"
echo ""
echo "Exemplos de criação de projetos:"
echo "  • Java + Maven:"
echo "    spring init --dependencies=web,data-jpa my-java-project"
echo "  • Kotlin + Gradle:"
echo "    spring init --language=kotlin --type=gradle-project --dependencies=web,data-jpa my-kotlin-project"
echo "  • Groovy + Maven:"
echo "    spring init --language=groovy --dependencies=web,data-jpa my-groovy-project"
