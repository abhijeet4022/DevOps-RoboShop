default:
	echo None
dev:
	git pull &>> /dev/null
	rm -rf  .terraform
	terraform init -backend-config=env-dev/state.tfvars
	terraform apply -auto-approve -var-file=env-dev/main.tfvars

#prod:
#	git pull &>> /dev/null
#	rm -rf  .terraform
#	terraform init -backend-config=env-prod/state.tfvars
#	terraform apply -auto-approve -var-file=env-prod/main.tfvars


#prod:
#	git pull 2>&1 | tee git_pull.log
#	rm -rf .terraform
#	terraform init -backend-config=env-prod/state.tfvars 2>&1 | tee terraform_init.log
#	terraform apply -auto-approve -var-file=env-prod/main.tfvars 2>&1 | tee terraform_apply.log

prod:
	#git pull &>> /dev/null
	rm -rf .terraform
	terraform init -backend-config=env-prod/state.tfvars
	terraform apply -auto-approve -var-file=env-prod/main.tfvars



dev-destroy:
	#git pull &>> /dev/null
	rm -rf .terraform
	terraform init -backend-config=env-dev/state.tfvars
	terraform destroy -auto-approve -var-file=env-dev/main.tfvars

prod-destroy:
	#git pull &>> /dev/null
	rm -rf  .terraform
	terraform init -backend-config=env-prod/state.tfvars
	terraform destroy -auto-approve -var-file=env-prod/main.tfvars


