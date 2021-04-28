ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end


    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Reports" do
          ol
          li link_to "Report on free boxes", reports_free_boxes_path
          li link_to "Report on clients", reports_clients_path
          li link_to "Report on box types", reports_box_types_path
          li link_to "Customer billing report", reports_customer_billing_path
          li link_to "Monthly revenue report", reports_monthly_revenue_path
        end
      end
      column do
        panel "Charts and graphics" do

        end
      end
    end

    columns do
        column do
          panel "Recent Contracts" do
            ul do
              Contract.last(10).map do |contract|
                li link_to contract.full_name, admin_contract_path(contract)
              end
            end
          end
        end
        column do
          panel "Actual tarrif" do
            ul do
              Tariff.last(10).map do |tariff|
                li link_to tariff.full_name, admin_tariff_path(tariff)
              end
            end
          end
        end
    end


  end # content
end
