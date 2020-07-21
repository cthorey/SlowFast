
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

.PHONY: train
train: ## Build docker image
	$(info *** train)
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
