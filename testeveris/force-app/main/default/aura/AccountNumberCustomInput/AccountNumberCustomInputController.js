({
	render : function(component, event, helper) {
		
	},
    init : function(component, event, helper) {
		
	},
 	onChange:function(component, event, helper) {
		var number  = component.find('accnum').get('v.value');
        if(number.split('').length == 11){
            component.find('tipodaconta').set('v.value','cpf')
        }else if(number.split('').length == 14){
            component.find('tipodaconta').set('v.value','cnpj')
        }else{
            component.find('tipodaconta').set('v.value','default')
        }
	},
    handleClick:function(component, event, helper) {
        
        component.set('v.success', false);
        component.set('v.error', false)
        
		var action = component.get('c.updateAccount'); 
       
        action.setParams({
            "accId" :component.get('v.accId'),
            "accNumber":component.find("accnum").get('v.value'),
            "tipodaConta":component.find('tipodaconta').get('v.value'),
            "nomeDaConta":component.find('nomeconta').get('v.value')
        });
        
        action.setCallback(this, function(a){
            
            var state = a.getState(); 
            
            if(state == 'SUCCESS') {
                console.log('Sucesso'),
                component.find('accnum').set('v.value','')
                component.find('tipodaconta').set('v.value','')
                component.find('nomeconta').set('v.value','')
                component.set('v.success', true)
            }else{
                component.set('v.error', true)
            }
            
        });
        $A.enqueueAction(action);
	}
})