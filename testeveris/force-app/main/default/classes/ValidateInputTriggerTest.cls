@isTest(seeAllData=true)
public class ValidateInputTriggerTest {
    @isTest
    public static void test(){
        // Seleciona o tipo de registro Parceiro
        List<RecordType > rTypes = [ Select id, Name from RecordType where Name='Parceiro'];
        RecordType partnerRecordType = rTypes[0];
        
        // Seleciona o tipo de registro Consumidor
        rTypes = [ Select id, Name from RecordType where Name='Consumidor Final'];
        RecordType customerRecordType = rTypes[0];
        
        //Criando conta do tipo parceiro
        
        Account acc = new Account();
        acc.AccountNumber = '111111111111111';
        acc.Type = 'CPF';
        //Especificando o tipo de registro da conta como Parceiro
        acc.RecordTypeId = partnerRecordType.Id;
        acc.Name = 'Conta teste';
        acc.ShippingCity = 'Test';
        acc.ShippingState = 'Minas Gerais';
        acc.ShippingCountry = 'Brazil';
        
        //Inserido nova na base de dados
        Database.SaveResult  res = Database.insert(acc);
        
        //Validando se a inserção foi bem sucedida
        System.assert(res.isSuccess());
        
        //Seleciona todas as oportunidades associadas à conta criada anteriormente
        List<Opportunity> opps = [ Select id, Name, CloseDate,StageName from Opportunity where AccountId = :res.Id ];
        
        //Validando se existe apenas uma oportunidade criada para a conta nova
        System.assertEquals(1, opps.size());
        
        //Validando se  oportunidade foi criada conforme os requisitos
        Opportunity opp = opps[0];
        System.assertEquals(opp.Name, 'Conta teste - opp Parceiro');
        System.assertEquals(opp.CloseDate, System.today() + 30);
        System.assertEquals(opp.StageName, 'Qualification');
        

        // //Criando conta do tipo consumidor final
        
        Account acc2 = new Account();
        acc2.AccountNumber = '111111111111111';
        acc2.Type = 'CNPJ';
        acc2.RecordTypeId = customerRecordType.Id;
        acc2.Name = 'Conta teste';   
        acc2.ShippingState = 'Minas Gerais';
        acc2.ShippingCountry = 'Brazil';
        
        //Inserindo nova conta na base de dados
		Database.SaveResult  res2 = Database.insert(acc2);
        
        
        //Validando se a inserção foi bem sucedida
        System.assert(res2.isSuccess());
        
        
        //Selecionando tarefas existentes para a conta recém criada
        List<Task> tasks = [ Select id, Subject, Priority, WhatId, Status from Task where WhatId = :res2.Id ];
        
        //Validando se foi criada apenas  uma tarefa para a conta
        System.assertEquals(1, tasks.size());
        
        //Validando se a tarefa foi criada de acordo com os requisitos
        Task task = tasks[0];
        System.assertEquals('Consumidor Final',task.Subject);
        System.assertEquals('Normal', task.Priority);
        System.assertEquals('Não iniciada', task.Status);
        
      	// Criando conta com Tipo inválido
        Account acc3 = new Account();
        acc3.AccountNumber = '111111111111111';
        acc3.Type = '';
        acc3.RecordTypeId = customerRecordType.Id;
        acc3.Name = 'Conta teste';   
        acc3.ShippingState = 'Minas Gerais';
        acc3.ShippingCountry = 'Brazil';
        
        //Tratamento de erro
        try{
            //Inserindo conta na base de dados
        	Database.SaveResult res3 = Database.insert(acc3);    
        }catch(DmlException e){
            //Mensagem de erro
            System.debug('O seguinte erro ocorreu' + e.getMessage());
		}

    }
    

    
}