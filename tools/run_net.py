#!/usr/bin/env python3
# Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
"""Wrapper to train and test a video classification model."""
from slowfast.utils.misc import launch_job
from slowfast.utils.parser import load_config, parse_args

from demo_net import demo
from test_net import test
from train_net import train
from visualization import visualize
import datetime
import os


def main():
    """
    Main function to spawn the train and test process.
    """
    args = parse_args()
    cfg = load_config(args)

    uuid = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    cfg.OUTPUT_DIR = os.path.join(cfg.OUTPUT_DIR, uuid)
    os.makedirs(cfg.OUTPUT_DIR)

    # Perform training.
    if cfg.TRAIN.ENABLE:
        launch_job(cfg=cfg, init_method=args.init_method, func=train)

    # # Perform multi-clip testing.
    # if cfg.TEST.ENABLE:
    #     launch_job(cfg=cfg, init_method=args.init_method, func=test)

    # if cfg.DEMO.ENABLE:
    #     launch_job(cfg=cfg, init_method=args.init_method, func=demo)

    if cfg.TENSORBOARD.ENABLE and cfg.TENSORBOARD.MODEL_VIS.ENABLE:
        launch_job(cfg=cfg, init_method=args.init_method, func=visualize)


if __name__ == "__main__":
    main()
