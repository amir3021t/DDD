﻿using Xunit;

namespace DDD.HealthcareDelivery.Application.Prescriptions
{
    using Core.Domain;
    using Core.Infrastructure.Serialization;
    using Domain.Prescriptions;
    using Infrastructure.Prescriptions;
    using Infrastructure;

    [Collection("Oracle")]
    public class OraclePharmaceuticalPrescriptionRevokerTests
        : PharmaceuticalPrescriptionRevokerTests<OracleFixture>
    {

        #region Constructors

        public OraclePharmaceuticalPrescriptionRevokerTests(OracleFixture fixture) : base(fixture)
        {
        }

        #endregion Constructors

        #region Methods

        protected override IRepository<PharmaceuticalPrescription> CreateRepository()
        {
            return new PharmaceuticalPrescriptionRepository
            (
                new Domain.Prescriptions.BelgianPharmaceuticalPrescriptionTranslator(),
                new StoredEventTranslator(new GenericDataContractSerializer<IDomainEvent>()),
                new OracleHealthcareContextFactory(this.Fixture.ConnectionFactory)
            );
        }

        #endregion Methods

    }
}