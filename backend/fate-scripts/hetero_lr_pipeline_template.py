"""Run a real FATE Pipeline job for vertical Hetero Logistic Regression.

Example:
python hetero_lr_pipeline_template.py \
  --guest-party-id 9999 --host-party-id 10000 --arbiter-party-id 10000 \
  --guest-namespace bank_credit_risk --guest-table bank_train_v1 \
  --host-namespace operator_credit_risk --host-table operator_train_v1
"""

import argparse

from pipeline.backend.pipeline import PipeLine
from pipeline.component import DataTransform, Evaluation, HeteroLR, Intersection, Reader
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
    parser.add_argument("--max-iter", type=int, default=30)
    parser.add_argument("--learning-rate", type=float, default=0.05)
    parser.add_argument("--batch-size", type=int, default=64)
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
    hetero_lr_0 = HeteroLR(
        name="hetero_lr_0",
        max_iter=args.max_iter,
        learning_rate=args.learning_rate,
        batch_size=args.batch_size,
        early_stop="diff",
        optimizer="rmsprop",
    )
    evaluation_0 = Evaluation(name="evaluation_0", eval_type="binary")

    pipeline.add_component(reader_0)
    pipeline.add_component(data_transform_0, data=Data(data=reader_0.output.data))
    pipeline.add_component(intersection_0, data=Data(data=data_transform_0.output.data))
    pipeline.add_component(hetero_lr_0, data=Data(train_data=intersection_0.output.data))
    pipeline.add_component(evaluation_0, data=Data(data=hetero_lr_0.output.data))

    pipeline.compile()
    pipeline.fit(JobParameters(backend=args.backend, work_mode=args.work_mode))
    print(f"FATE_JOB_ID={pipeline.get_job_id()}")


if __name__ == "__main__":
    main()
