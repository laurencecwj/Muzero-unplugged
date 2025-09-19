import wandb 
from torch.utils.tensorboard import SummaryWriter

writer = None
def init_log():
    global writer
    if writer is None:
        wandb.init(project="muzero_unplugged")
        wandb.tensorboard.patch()
        writer = SummaryWriter('runs')

def write_scales(epoch, items):
    for _k, _v in items.items():
        writer.add_scalar(_k, _v, global_step=epoch)

        