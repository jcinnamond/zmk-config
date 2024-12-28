west_build = west build -s zmk/app
left_board = corneish_zen_v1_left
right_board = corneish_zen_v1_right
dzmk_config = -DZMK_CONFIG=/home/jc/zmk-config/config

.PHONY: default
default: update build/left.uf2 build/right.uf2

.PHONY: clean
clean:
	rm -rf build/left
	rm -f build/left.uf2
	rm -rf build/right
	rm -f build/right.uf2

.PHONY: clean-all
clean-all: clean
	rm -rf .west zephyr zmk

.PHONY: init
init:
	west init -l config
	west update
	west zephyr-export

.PHONY: update
	west update

build/left.uf2: build/left/zephyr/zmk.uf2
	cp build/left/zephyr/zmk.uf2 build/left.uf2

build/right.uf2: build/right/zephyr/zmk.uf2
	cp build/right/zephyr/zmk.uf2 build/right.uf2

build/left/zephyr/zmk.uf2: $(wildcard config/*)
	$(west_build) -d build/left -b $(left_board) -- $(dzmk_config)

build/right/zephyr/zmk.uf2: $(wildcard config/*)
	$(west_build) -d build/right -b $(right_board) -- $(dzmk_config)

