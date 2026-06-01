"""Run a real FATE Pipeline job for vertical Hetero SecureBoost."""

import argparse

from pipeline.backend.pipeline import PipeLine
from pipeline.component import DataTransform, Evaluation, HeteroSecureBoost, Intersection, Reader
from pipeline.interface import Data
from pipeline.runtime.entity import JobParameters


def build_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--guest-party-id", type=int, required=True)
    parser.add_argument("--host-party-id", type=int, required=True)
    parser.add_argument("--arbiter-party-id", type=int, required=True)
    parser.add_argument("--guest-namespace", required=True)
    parser.add_argument("--guest-table", required=True)
    parser.add_argument("--host-namespace", required=True)
    parser.add_argument("--host-table", required=True)
    parser.add_argument("--work-mode", type=int, default=0)
    parser.add_argument("--backend", type=int, default=0)
    parser.add_argument("--num-trees", type=int, default=50)
    parser.add_argument("--tree-depth", type=int, default=4)
    parser.add_argument("--learning-rate", type=float, default=0.1)
    return parser.parse_args()


def main():
    args = build_args()

    pipeline = (
        PipeLine()
        .set_initiator(role="guest", party_id=args.guest_party_id)
        .set_roles(guest=args.guest_party_id, host=args.host_party_id, arbiter=args.arbiter_party_id)
    )

    reader_0 = Reader(name="reader_0")
    reader_0.get_party_instance(role="guest", party_id=args.guest_party_id).component_param(
        table={"name": args.guest_table, "namespace": args.guest_namespace}
    )
    reader_0.get_party_instance(role="host", party_id=args.host_party_id).component_param(
        table={"name": args.host_table, "namespace": args.host_namespace}
    )

    data_transform_0 = DataTransform(name="data_transform_0")
    data_transform_0.get_party_instance(role="guest", party_id=args.guest_party_id).component_param(
        with_label=True,
        label_name="is_overdue",
        output_format="dense",
    )
    data_transform_0.get_party_instance(role="host", party_id=args.host_party_id).component_param(
        with_label=False,
        output_format="dense",
    )

    intersection_0 = Intersection(name="intersection_0")
    secureboost_0 = HeteroSecureBoost(
        name="hetero_secureboost_0",
        num_trees=args.num_trees,
        tree_param={"max_depth": args.tree_depth},
        learning_rate=args.learning_rate,
        objective_param={"objective": "cross_entropy"},
    )
    evaluation_0 = Evaluation(name="evaluation_0", eval_type="binary")

    pipeline.add_component(reader_0)
    pipeline.add_component(data_transform_0, data=Data(data=reader_0.output.data))
    pipeline.add_component(intersection_0, data=Data(data=data_transform_0.output.data))
    pipeline.add_component(secureboost_0, data=Data(train_data=intersection_0.output.data))
    pipeline.add_component(evaluation_0, data=Data(data=secureboost_0.output.data))

    pipeline.compile()
    pipeline.fit(JobParameters(backend=args.backend, work_mode=args.work_mode))
    job_id = pipeline.get_train_job_id() if hasattr(pipeline, "get_train_job_id") else getattr(pipeline, "_train_job_id", "")
    print(f"FATE_JOB_ID={job_id}")


if __name__ == "__main__":
    main()
