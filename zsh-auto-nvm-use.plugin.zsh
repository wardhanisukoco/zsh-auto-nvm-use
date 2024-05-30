
# Auto load version node if exists .nvmrc
[[ -n "$ZSH_NVM_AUTOLOAD" ]] || ZSH_NVM_AUTOLOAD=true

load-nvmrc() {
	local node_version="$(nvm version)"
	local nvmrc_path="$(nvm_find_nvmrc)"

	if [ -n "$nvmrc_path" ]
	then
		local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

		if [ "$nvmrc_node_version" = "N/A" ]
		then
			nvm install
		fi

		if [ "$nvmrc_node_version" != "$node_version" ]
		then
			nvm use
		fi
	elif [ "$node_version" != "$(nvm version default)" ]  
	then
		echo "Reverting to nvm default version"
		nvm use default
	fi
}

if [[ "$ZSH_NVM_AUTOLOAD" == "true" ]]
then
	autoload -U add-zsh-hook
	add-zsh-hook chpwd load-nvmrc
	load-nvmrc
fi
