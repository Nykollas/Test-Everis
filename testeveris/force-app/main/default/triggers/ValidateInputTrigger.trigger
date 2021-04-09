trigger ValidateInputTrigger on Account (after update, after insert) {
    for(Account acc:Trigger.New){
        //Recebendo o id do tipo de registro "Parceiro"
        Id partnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parceiro').getRecordTypeId();
        
        //Recebendo o id do tipo de registro "Parceiro"
        Id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumidor Final').getRecordTypeId();
        
        //Chegando se o tipo da conta é CPF ( Pessoa Física ) e se o CPF informado é válido
        Boolean isCPFValid = (Utils.validaCPF(acc.AccountNumber) && acc.Type=='CPF');
        
        //Chegando se o tipo da conta é CNPJ ( Pessoa Jurídica ) e se o CNPJ informado é válido
        Boolean isCNPJValid = (Utils.validaCNPJ(acc.AccountNumber) && acc.Type=='CNPJ');
        
        
        //Se o número do cliente informado não corresponder a um CPF ou CNPJ válido de acordo com o tipo da conta, enviar alerta de erro
        if(!(isCPFValid || isCNPJValid )){
          acc.adderror('Número do cliente é inválido');
            
        //Se o registro de conta novo possuir um número do cliente
        //que corresponde a um CPF ou CNPJ válido de acordo com o tipo da conta
        //e o contexto for de inserção
        }else if(Trigger.isInsert){
            // Checa se o tipo de registro da conta inserida é "Parceiro"
            if(acc.RecordTypeId == partnerRecordTypeId ){
                // Instancia nova oportunidade 
                // informando o nome, data de fechamento, conta relacionada, e definindo fase como "Qualification"
                Opportunity newOpp = new Opportunity(
                    									Name = acc.Name + ' - opp Parceiro',
                    									CloseDate = System.today() + 30,
                    									AccountId = acc.Id,
                    									StageName='Qualification'
                									 );
                //Inseri oportunidade instanciada na base 
                Database.SaveResult res = Database.insert(newOpp);
   
            //Se o tipo de registro da conta inserida não for "Parceiro" presume se que seja "Consumidor Final"
            }else{
                //Cria tarefa com o assunto definido como "Consumidor Final", relacionado à conta inserida,
                // status não iniciado e prioridade normal
                Task newTask = new Task(Subject='Consumidor Final', WhatId=acc.Id, Status='Não iniciada', Priority='Normal');
                //Inseri nova tarefa na base de dados.
                Database.SaveResult res2 = Database.insert(newTask);
 
            } 
		}
    }
}