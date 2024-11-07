# ScriptDeBackUpLinux
Script para fazer backup ou restaurar uma versão no linux.
Lembrando que caso queira usar para restaurar, deve-se ter os arquivos de backup salvos previamente.

Como Funciona o Script:

    Escolha de Ação: No início, o script pergunta se você deseja fazer um backup ou restaurar o sistema.
    Backup:
        Se escolher fazer backup, ele:
            Cria um backup das configurações do sistema (/etc).
            Cria um backup das configurações do usuário (~/.config, ~/.bashrc, ~/.profile, ~/.local).
            Salva a lista de pacotes instalados em installed_packages.list.
    Restauração:
        Se escolher restaurar:
            Reinstala os pacotes listados em installed_packages.list, se disponível.
            Restaura as configurações do sistema de backup_etc_configs.tar.gz, se disponível.
            Restaura as configurações do usuário de backup_home_configs.tar.gz, se disponível.
            Pergunta ao usuário se deseja reiniciar imediatamente ou manualmente depois.
    Reinicialização:
        O script oferece a opção de reinicialização automática após a restauração, caso o usuário queira.
