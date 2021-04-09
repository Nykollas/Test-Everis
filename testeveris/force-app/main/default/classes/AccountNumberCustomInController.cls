public  class AccountNumberCustomInController {
    @AuraEnabled
    //Método para atualizar conta a partir do componente customizado
    public static  void updateAccount(String accId, String accNumber, String tipodaConta, String nomeDaConta){
        //Instanciando nova conta
        Account toUpdate = new Account(Id=accId, 
                                       AccountNumber=accNumber,
                                       Type=tipodaConta,
                                       Name=nomeDaConta);
        
       Database.SaveResult res = Database.update(toUpdate);
    }
    
}