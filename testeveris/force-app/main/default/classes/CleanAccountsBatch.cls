//Classe para processamento em lote
global class CleanAccountsBatch implements Database.Batchable<sObject>, Database.Stateful{

    //Método de início, responsável por receber os valores a serem processados
    global Database.QueryLocator start(Database.BatchableContext bc){
        //Especificando a primeira data considerando o intervalo de datas dos últimos 90 dias
		Date taskDate = System.today() - 90;
        
        //Especificando a primeira data considerando o intervalo de datas dos últimos 120 dias
        Date opportunityDate = System.today() - 120;
        
        //Instanciando lista de oportunidades
        List<String> oppIds = new List<String>();
        
        //Seleciona  histórico de modificações na fase das Oportunidades, 
        //somente as alterações que ocorreram nos últimos 120 dias, e que foram para  fase Closed Won
        List<OpportunityHistory> oppHist = [ select id, OpportunityId from OpportunityHistory where CreatedDate > :opportunityDate and StageName='Closed Won'];
        
        //Gerando lista de ids de oportunidades associadas aos históricos obtidos anteriormente
        //ou seja gerando lista de ids de oportunidades fechadas nos últimos 120 dias
        for(OpportunityHistory oppH:oppHist){
            oppIds.add(oppH.OpportunityId);
        }
        
    	//Se o contexto de execução não for de teste
        if (!Test.isRunningTest()){
            //Obtém todas as contas, com a lista de tarefas relacionadas criadas nos últimos 90 dias, com a lista de oportunidade fechadas nos últimos 120 dias
            //E com  uma lista de oportunidades em fase de negociação
            return Database.getQueryLocator('Select id, Name, Inativa__c,  ( Select id from Tasks where CreatedDate > :taskDate ), ( Select id, StageName from Opportunities where StageName=\'Negotiation\' OR Id in :oppIds )  from Account');
        } else{
            //Obtém todas as contas, com a lista de tarefas relacionadas criadas nos últimos 90 dias e com a lista de oportunidade fechadas nos últimos 120 dias
            //Limita o resultado a 20 registros
            return Database.getQueryLocator('Select id, Name, Inativa__c,  ( Select id from Tasks where CreatedDate > :taskDate ), ( Select id, StageName from Opportunities where StageName=\'Negotiation\' OR Id in :oppIds )  from Account limit 20');
        }        
    }   
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
       //Lista de contas que serão atualizadas
       List<Account> accToUpdate = new List<Account>();
        
       //Itera sobre contas do lote
       for(Account acc:scope){
           	//Checa se a conta possui Tarefa criada nos últimos 90 dias e se  conta possui oportunidade fechada nos últimos 120 dias
            if(acc.Tasks.size() == 0 && acc.Opportunities.size() == 0){
                //Define contas como inativa
                acc.Inativa__c=true;
            }
           accToUpdate.add(acc);
        }
        //Atualiza registros de contas na base
        //Obs: tudo ou nada desativado
        List<Database.SaveResult> res = Database.update(accToUpdate, false);
        // Considerando uma org com registros com número de cliente inválidos ou tipos não definidos corretamente
        // Itera sobre os resultados da atualização com o fim de executar uma em caso de erros
        for (Database.SaveResult re : res) {
            if (!re.isSuccess()) {
                for(Database.Error err : re.getErrors()) {
                    /*
                    	Aqui podemos executar uma ação, como por exemplo gerar um csv 
						( nesse caso os dados devem ser armazenados fora do escopo desse método preferencialmento no escopo da classe)
						para enviá-lo no método finish para os administradorrd Salesforce notificando os
						sobre os erros de atualização,suas causas e quais registros estão com problemas nesse sentido. 

					*/
                }
            }
		}
        
    }
    
    global void finish(Database.BatchableContext bc){
		System.debug('Concluído');
    	
    }
}