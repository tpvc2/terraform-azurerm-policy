resource "azurerm_policy_definition" "main-policy" {
  name        = coalesce(var.policy_custom_name, local.policy_name)
  description = coalesce(var.policy_description, local.policy_name)

  policy_type         = "Custom"
  mode                = var.policy_mode
  display_name        = coalesce(var.policy_custom_name, local.policy_name)
  management_group_id = var.policy_mgmt_group_id

  policy_rule = var.policy_rule_content
  parameters  = var.policy_parameters_content
}

resource "azurerm_policy_assignment" "assign-policy" {
  for_each             = var.policy_assignments
  name                 = each.key
  policy_definition_id = azurerm_policy_definition.main-policy.id
  scope                = each.value.scope

  location     = var.location
  display_name = each.value.display_name
  description  = each.value.description
  parameters   = each.value.parameters

  identity {
    type = each.value.identity_type
  }
}
