*** Settings ***

Library    DatabaseLibrary

Resource    ../data/connectionDB.robot

*** Keywords ***

Connect
    Connect To Database    dbapiModuleName=${dadosAcesso.dbDriver}     dbName=${dadosAcesso.dbName}     dbUsername=${dadosAcesso.dbUser}     dbPassword=${dadosAcesso.dbPass}     dbHost=${dadosAcesso.dbHost}     dbPort=${dadosAcesso.dbPort} 


Disconnect
    Disconnect From Database