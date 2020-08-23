# ConfigHostCloudera5.16.2
Shell Script para realizar configurações em Centos 7.8 (minimum installation) voltado para configurar Cloudera Manager 5.16.2 (Quick Start).

O Script foi divido em duas etapas a primeira etapa será realiazdo as configurações e será feito um reboot no S.O. Após logar novamente no sistema com o mesmo usuário que foi executado o Script o mesmo irá retomar as configurações e executar a segunda etapa de configuração.

O Script faz as seguintes configurações:

Parte 1 (Antes do Reboot):
- Configuração hostname (interativo);
- Configuração inteface de rede (interativo) ;
- Desabilita SELinux ;

Parte 2 (Após Reboot):
- Configuração regras de firewall ;
- Instalação de pacotes utilitários S.O ;
- Configura o repositório do Cloudera Manager 5.16.2 
