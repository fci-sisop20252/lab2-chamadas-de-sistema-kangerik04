#!/bin/bash

# Cores para melhor visualização
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==========================================================${NC}"
echo -e "${BLUE}     Configuração do GitHub Personal Access Token (PAT)   ${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo ""

# Verificação de segurança
echo -e "${RED}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║                    ⚠️  AVISO IMPORTANTE ⚠️             ║${NC}"
echo -e "${RED}╠════════════════════════════════════════════════════════╣${NC}"
echo -e "${RED}║  EXECUTE ESTE SCRIPT APENAS EM SUA MÁQUINA PESSOAL!    ║${NC}"
echo -e "${RED}║                                                        ║${NC}"
echo -e "${RED}║  ❌ NÃO execute em computadores do laboratório         ║${NC}"
echo -e "${RED}║  ❌ NÃO execute em computadores compartilhados         ║${NC}"
echo -e "${RED}║  ❌ NÃO compartilhe seu token com NINGUÉM              ║${NC}"
echo -e "${RED}║                                                        ║${NC}"
echo -e "${RED}║  Seu token dá acesso completo aos seus repositórios!   ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Confirmação de segurança
read -p "Você está em sua máquina pessoal? (digite 'sim' para continuar): " CONFIRMACAO

if [ "$CONFIRMACAO" != "sim" ]; then
    echo -e "${RED}Configuração cancelada. Execute apenas em sua máquina pessoal.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Continuando com a configuração...${NC}"
echo ""

# Verificar se git está instalado
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git não está instalado. Por favor, instale o Git primeiro.${NC}"
    echo "Ubuntu/Debian: sudo apt install git"
    echo "Fedora: sudo dnf install git"
    echo "macOS: brew install git"
    exit 1
fi

# Passo 1: Configurar nome e email (se ainda não configurado)
echo -e "${YELLOW}═══ Passo 1: Configuração do Git ═══${NC}"
echo ""

CURRENT_NAME=$(git config --global user.name)
CURRENT_EMAIL=$(git config --global user.email)

if [ -z "$CURRENT_NAME" ]; then
    echo "Seu nome ainda não está configurado no Git."
    read -p "Digite seu nome completo: " USER_NAME
    git config --global user.name "$USER_NAME"
    echo -e "${GREEN}✓ Nome configurado: $USER_NAME${NC}"
else
    echo -e "${GREEN}✓ Nome já configurado: $CURRENT_NAME${NC}"
    read -p "Deseja alterar? (s/N): " CHANGE_NAME
    if [ "$CHANGE_NAME" = "s" ] || [ "$CHANGE_NAME" = "S" ]; then
        read -p "Digite seu novo nome: " USER_NAME
        git config --global user.name "$USER_NAME"
        echo -e "${GREEN}✓ Nome atualizado${NC}"
    fi
fi

echo ""

if [ -z "$CURRENT_EMAIL" ]; then
    echo "Seu email ainda não está configurado no Git."
    read -p "Digite seu email do GitHub: " USER_EMAIL
    git config --global user.email "$USER_EMAIL"
    echo -e "${GREEN}✓ Email configurado: $USER_EMAIL${NC}"
else
    echo -e "${GREEN}✓ Email já configurado: $CURRENT_EMAIL${NC}"
    read -p "Deseja alterar? (s/N): " CHANGE_EMAIL
    if [ "$CHANGE_EMAIL" = "s" ] || [ "$CHANGE_EMAIL" = "S" ]; then
        read -p "Digite seu novo email: " USER_EMAIL
        git config --global user.email "$USER_EMAIL"
        echo -e "${GREEN}✓ Email atualizado${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}═══ Passo 2: Criar Personal Access Token no GitHub ═══${NC}"
echo ""
echo -e "${BLUE}Siga estas instruções cuidadosamente:${NC}"
echo ""
echo "1. Clique neste link (ou copie para o navegador):"
echo -e "   ${BLUE}https://github.com/settings/tokens/new${NC}"
echo ""
echo "2. Faça login no GitHub com sua conta"
echo ""
echo "3. Configure o token:"
echo -e "   • Nome do token: ${GREEN}Git Lab SO 2025${NC} (ou outro nome descritivo)"
echo -e "   • Expiração: ${GREEN}90 days${NC} (recomendado para o semestre)"
echo "   • Escopos necessários - marque APENAS:"
echo -e "     ☑️  ${GREEN}repo${NC} (Full control of private repositories)"
echo ""
echo -e "4. Role até o final da página e clique em ${GREEN}Generate token${NC}"
echo ""
echo -e "5. ${RED}IMPORTANTE:${NC} O token aparecerá APENAS UMA VEZ!"
echo "   Copie o token que começa com 'ghp_...'"
echo ""
echo -e "${YELLOW}Pressione ENTER quando estiver pronto para colar o token...${NC}"
read

# Passo 3: Coletar o token
echo ""
echo -e "${YELLOW}═══ Passo 3: Inserir o Token ═══${NC}"
echo ""
echo "Cole seu Personal Access Token abaixo:"
echo "(ao colar, por segurança não vai aparecer nada)"
echo ""

# Ler token com segurança (não mostra na tela)
read -s -p "Token: " TOKEN
echo ""

# Validar token
if [ -z "$TOKEN" ]; then
    echo -e "${RED}✗ Token não pode estar vazio!${NC}"
    exit 1
fi

if [[ ! "$TOKEN" =~ ^ghp_ ]]; then
    echo -e "${YELLOW}⚠️  Aviso: O token normalmente começa com 'ghp_'${NC}"
    read -p "Deseja continuar mesmo assim? (s/N): " CONTINUE
    if [ "$CONTINUE" != "s" ] && [ "$CONTINUE" != "S" ]; then
        echo -e "${RED}Configuração cancelada.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Token recebido (${#TOKEN} caracteres)${NC}"
echo ""

# Passo 4: Configurar credenciais
echo -e "${YELLOW}═══ Passo 4: Configurar Autenticação ═══${NC}"
echo ""

# Configurar credential helper
git config --global credential.helper store

# Configurar URL com token
git config --global url."https://${TOKEN}@github.com/".insteadOf "https://github.com/"

echo -e "${GREEN}✓ Autenticação configurada com sucesso!${NC}"
echo ""

# Passo 5: Testar configuração
echo -e "${YELLOW}═══ Passo 5: Testar Configuração ═══${NC}"
echo ""
echo "Testando conexão com GitHub..."

# Tentar acessar um endpoint da API do GitHub
if curl -s -H "Authorization: token $TOKEN" https://api.github.com/user > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Conexão com GitHub funcionando!${NC}"
    echo ""
    
    # Obter informações do usuário
    USERNAME=$(curl -s -H "Authorization: token $TOKEN" https://api.github.com/user | grep -o '"login":"[^"]*' | sed 's/"login":"//')
    if [ ! -z "$USERNAME" ]; then
        echo -e "${GREEN}✓ Autenticado como: $USERNAME${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Não foi possível verificar a conexão automaticamente.${NC}"
    echo "   Isso pode ser normal. Teste clonando um repositório privado."
fi

echo ""
echo -e "${BLUE}==========================================================${NC}"
echo -e "${GREEN}           🎉 Configuração Concluída com Sucesso! 🎉      ${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo ""
echo -e "${GREEN}Você já pode:${NC}"
echo "• Clonar repositórios privados"
echo "• Fazer push para seus repositórios"
echo "• Usar todos os comandos git normalmente"
echo ""
echo -e "${YELLOW}Exemplo de uso:${NC}"
echo "git clone https://github.com/fci-sisop20252/lab2-syscalls-SEU_USUARIO.git"
echo ""
echo -e "${RED}Lembretes de Segurança:${NC}"
echo "• Seu token está salvo em ~/.git-credentials"
echo "• NUNCA compartilhe este arquivo ou seu token"
echo "• Se suspeitar que o token foi comprometido, revogue-o imediatamente em:"
echo "  https://github.com/settings/tokens"
echo ""
echo -e "${BLUE}Para revogar este token no futuro:${NC}"
echo "1. Acesse: https://github.com/settings/tokens"
echo "2. Encontre o token 'Git Lab SO 2025'"
echo "3. Clique em 'Delete'"
echo ""

# Criar arquivo de backup das configurações
BACKUP_FILE="$HOME/.git-config-backup-$(date +%Y%m%d-%H%M%S).txt"
echo "Data: $(date)" > "$BACKUP_FILE"
echo "Nome: $(git config --global user.name)" >> "$BACKUP_FILE"
echo "Email: $(git config --global user.email)" >> "$BACKUP_FILE"
echo "Token configurado: Sim (não salvo por segurança)" >> "$BACKUP_FILE"
chmod 600 "$BACKUP_FILE"

echo -e "${GREEN}✓ Backup das configurações salvo em: $BACKUP_FILE${NC}"
echo ""
echo -e "${GREEN}Configuração finalizada! Você está pronto para usar o Git com GitHub.${NC}"