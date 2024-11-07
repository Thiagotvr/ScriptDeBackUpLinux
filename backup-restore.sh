#!/bin/bash

# Nome dos arquivos de backup
BACKUP_ETC="backup_etc_configs.tar.gz"
BACKUP_HOME="backup_home_configs.tar.gz"
PACKAGE_LIST="installed_packages.list"

# Função para fazer backup
backup_system() {
    echo "Iniciando backup do sistema..."

    # Backup dos arquivos de configuração do sistema
    echo "Criando backup das configurações do sistema em /etc..."
    sudo tar -czvf "$BACKUP_ETC" /etc

    # Backup dos arquivos de configuração do usuário
    echo "Criando backup das configurações do usuário em ~/.config e arquivos .bashrc, .profile..."
    tar -czvf "$BACKUP_HOME" ~/.config ~/.bashrc ~/.profile ~/.local

    # Backup da lista de pacotes instalados
    echo "Salvando a lista de pacotes instalados em $PACKAGE_LIST..."
    dpkg --get-selections > "$PACKAGE_LIST"

    echo "Backup concluído. Arquivos salvos:"
    echo "- $BACKUP_ETC"
    echo "- $BACKUP_HOME"
    echo "- $PACKAGE_LIST"
}

# Função para restaurar o sistema
restore_system() {
    echo "Iniciando restauração do sistema..."

    # Restaura a lista de pacotes instalados
    if [ -f "$PACKAGE_LIST" ]; then
        echo "Restaurando a lista de pacotes instalados..."
        sudo dpkg --set-selections < "$PACKAGE_LIST"
        sudo apt-get dselect-upgrade
    else
        echo "Arquivo $PACKAGE_LIST não encontrado. Pulando esta etapa."
    fi

    # Restaura as configurações do sistema
    if [ -f "$BACKUP_ETC" ]; then
        echo "Restaurando as configurações do sistema em /etc..."
        sudo tar -xzvf "$BACKUP_ETC" -C /
    else
        echo "Arquivo $BACKUP_ETC não encontrado. Pulando esta etapa."
    fi

    # Restaura as configurações do usuário
    if [ -f "$BACKUP_HOME" ]; then
        echo "Restaurando as configurações do usuário em ~/.config..."
        tar -xzvf "$BACKUP_HOME" -C ~/
    else
        echo "Arquivo $BACKUP_HOME não encontrado. Pulando esta etapa."
    fi

    # Pergunta sobre reinicialização
    read -p "Deseja reiniciar o sistema agora? (s/n): " RESTART
    if [[ "$RESTART" =~ ^[Ss]$ ]]; then
        echo "Reiniciando o sistema..."
        sudo reboot
    else
        echo "Reinicialização manual pode ser feita posteriormente."
    fi
}

# Menu principal
echo "Escolha uma opção:"
echo "1) Fazer backup do sistema"
echo "2) Restaurar o sistema de um backup"
read -p "Opção (1/2): " OPTION

case $OPTION in
    1)
        backup_system
        ;;
    2)
        restore_system
        ;;
    *)
        echo "Opção inválida. Saindo."
        exit 1
        ;;
esac

