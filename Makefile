
.PHONY: build
build: ## Build docker image
	$(info *** Building docker image: xihelm/slowfast:clogloss)
	@docker build \
		--tag xihelm/slowfast:clogloss \
		--file ./Dockerfile \
		.

.PHONY: notebook
notebook: ## Build docker image
	$(info *** notebook)
	@docker run \
		--volume /mnt/hdd/omatai/models:/workdir/models \
		--volume /mnt/hdd/omatai/data:/workdir/data \
		--volume ~/.aws:/root/.aws \
		--volume ~/.pgpass:/root/.pgpass \
		--volume ~/workdir/SlowFast:/workdir/SlowFast \
		--runtime=nvidia \
		--publish 8888:8888 \
	--env NVIDIA_VISIBLE_DEVICES=0 \
	  -d \
    xihelm/slowfast:clogloss /workdir/SlowFast/run_jupyter.sh

.PHONY: train_c2d
train_c2d: ## Build docker image
	$(info *** train_c2d)
	@docker run \
		--volume /mnt/hdd/omatai/models:/workdir/models \
		--volume /mnt/hdd/omatai/data:/workdir/data \
		--volume ~/.aws:/root/.aws \
		--volume ~/.pgpass:/root/.pgpass \
		--volume ~/workdir/SlowFast:/workdir/SlowFast \
		--env NVIDIA_VISIBLE_DEVICES='0,1,2' \
		--shm-size="16G" \
		--runtime=nvidia \
	  -it \
    xihelm/slowfast:clogloss python -u SlowFast/tools/run_net.py --cfg SlowFast/configs/Kinetics/C2D_8x8_R50_clogloss.yaml


.PHONY: train_slow
train_slow: ## Build docker image
	$(info *** train_slow)
	@docker run \
		--volume /mnt/hdd/omatai/models:/workdir/models \
		--volume /mnt/hdd/omatai/data:/workdir/data \
		--volume ~/.aws:/root/.aws \
		--volume ~/.pgpass:/root/.pgpass \
		--volume ~/workdir/SlowFast:/workdir/SlowFast \
		--env NVIDIA_VISIBLE_DEVICES='0,1,2' \
		--shm-size="16G" \
		--runtime=nvidia \
	  -d \
    xihelm/slowfast:clogloss python -u SlowFast/tools/run_net.py --cfg SlowFast/configs/Kinetics/SLOW_4x16_R50_clogloss.yaml

.PHONY: train_slowfast
train_slowfast: ## Build docker image
	$(info *** train_slowfast)
	@docker run \
		--volume /mnt/hdd/omatai/models:/workdir/models \
		--volume /mnt/hdd/omatai/data:/workdir/data \
		--volume ~/.aws:/root/.aws \
		--volume ~/.pgpass:/root/.pgpass \
		--volume ~/workdir/SlowFast:/workdir/SlowFast \
		--env NVIDIA_VISIBLE_DEVICES='0,1,2' \
		--shm-size="16G" \
		--runtime=nvidia \
	  -d \
    xihelm/slowfast:clogloss python -u SlowFast/tools/run_net.py --cfg SlowFast/configs/Kinetics/SLOWFAST_4x16_R50_clogloss.yaml
