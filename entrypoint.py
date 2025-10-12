import os
import sys
import subprocess
import torch

print('PyTorch version:', torch.__version__)

if torch.cuda.is_available():
    print('CUDA available: True')
    print('CUDA device count:', torch.cuda.device_count())
    print('Current device:', torch.cuda.current_device())
else:
    print('CUDA available: False')
    print('Using CPU')

# 交互模式
if os.environ.get('INTERACTIVE') == '1':
    print('Interactive mode enabled. Starting bash shell...')
    subprocess.run(['bash'])
else:
    # 1) Lint 检查
    print('Running flake8 lint...')
    subprocess.run(['flake8', '/workspace'], check=False)

    # 2) 单元测试 / CI 脚本
    ci_script = os.environ.get('CI_SCRIPT', '/workspace/test_gpu.py')
    if os.path.exists(ci_script):
        print(f'Executing CI script: {ci_script}')
        subprocess.run([sys.executable, ci_script], check=True)
    else:
        print(f'No CI script found at {ci_script}, skipping.')

    print('CI/CD workflow completed.')