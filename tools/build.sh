#!/bin/bash

# 函数：显示用法
usage() {
    echo "使用方法: $0 --registry <镜像仓库> --namespace <namespace> --branch <分支> --repo <构建仓库>"
    exit 1
}
# 默认参数
REGISTRY="docker.io"
NAMESPACE="dongshanyi"
BRANCH="master"
REPO=""
# 读取参数
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --registry) REGISTRY="$2"; shift 2 ;;
        --namespace) NAMESPACE="$2"; shift 2 ;;
        --branch) BRANCH="$2"; shift 2 ;;
        --repo) REPO="$2"; shift 2 ;;
        -r) REGISTRY="$2"; shift 2 ;;
        -n) NAMESPACE="$2"; shift 2 ;;
        -b) BRANCH="$2"; shift 2 ;;
        *) usage ;;
    esac
done

# 检查必传参数
if [[ -z "$BRANCH" || -z "$REPO" ]]; then
    usage
fi

# 根据分支名称执行不同的操作
case $BRANCH in
    master)
        echo "执行针对 master 分支的操作..."
        ./tools/build.py $REPO --config-file ./etc/kolla/kolla-build.conf --push --registry $REGISTRY --namespace $NAMESPACE --tag latest
        ;;
    develop)
        echo "执行针对 develop 分支的操作..."
        ./tools/build.py $REPO --config-file ./etc/kolla/kolla-build.conf --push --registry $REGISTRY --namespace $NAMESPACE --tag develop
        ;;
    *)
        echo "执行针对其他分支 ($BRANCH) 的操作..."
        ./tools/build.py $REPO --config-file ./etc/kolla/kolla-build.conf --push --registry $REGISTRY --namespace $NAMESPACE --tag $BRANCH
        ;;
esac
