#!/bin/bash

# 函数：显示用法
usage() {
    echo "使用方法: $0 --registry <仓库> --namespace <namespace> --branch <分支>"
    exit 1
}

# 检查参数数量
if [ "$#" -ne 6 ]; then
    usage
fi

# 读取参数
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --registry) REGISTRY="$2"; shift 2 ;;
        --namespace) NAMESPACE="$2"; shift 2 ;;
        --branch) BRANCH="$2"; shift 2 ;;
        -r) REGISTRY="$2"; shift 2 ;;
        -n) NAMESPACE="$2"; shift 2 ;;
        -b) BRANCH="$2"; shift 2 ;;
        *) usage ;;
    esac
done

# 根据分支名称执行不同的操作
case $BRANCH in
    master)
        echo "执行针对 master 分支的操作..."
        ./tools/build.py nova --config-file ./etc/kolla/kolla-build.conf --push --registry docker.io --namespace dongshanyi --tag latest
        ;;
    develop)
        echo "执行针对 develop 分支的操作..."
        ./tools/build.py nova --config-file ./etc/kolla/kolla-build.conf --push --registry docker.io --namespace dongshanyi --tag develop
        ;;
    *)
        echo "执行针对其他分支 ($BRANCH) 的操作..."
        ./tools/build.py nova --config-file ./etc/kolla/kolla-build.conf --push --registry docker.io --namespace dongshanyi --tag $BRANCH
        ;;
esac
