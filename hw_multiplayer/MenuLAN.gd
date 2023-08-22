extends Control

func _ready():
	Networking.lista_alterada.connect(self.lista_alterada)

func _on_criar_pressed():
	Networking.atualizar_nome($NomeEdit.text)
	Networking.criar_servidor()
	pass

func _on_conectar_pressed():
	Networking.atualizar_ip($IpEdit.text)
	Networking.atualizar_nome($NomeEdit.text)
	Networking.entrar_servidor()
	pass

func _on_comecar_pressed():
	if multiplayer.is_server():
		rpc("comecar_jogo")
	pass

@rpc("any_peer", "call_local")
func comecar_jogo():
	get_tree().change_scene_to_file("res://Fase.tscn")

func lista_alterada():
	var lista = Networking.retornar_jogadores() as Array
	$ListaJogadores.clear()
	for i in range(lista.size()):
		if lista[i][0] == Networking.id:
			$ListaJogadores.add_item(lista[i][1] + str(" (você)"))
		else:
			$ListaJogadores.add_item(lista[i][1])
	pass



