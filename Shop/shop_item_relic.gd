extends ShopItem

var relic : Relic
@export var relicImage : TextureButton
@export var clickHandler : ClickHandler

func _ready() -> void:
	var rand : RandomNumberGenerator = RandomNumberGenerator.new()
	relic = load(ShopManager.shop_relic_pool[rand.randi_range(0, ShopManager.shop_relic_pool.size() - 1)])
	
	relicImage.texture_normal = load(relic.sprite_path)
	clickHandler.on_click.connect(on_shop_item_clicked)
	super()

func _give_player_item() -> void:
	InventoryManager.relic_component.add_relic(relic)
